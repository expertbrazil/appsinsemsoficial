class MonthlyPayment < ApplicationRecord
  # default_scope { order(paid: :asc, due_date: :asc) }

  belongs_to :people_associated

  validates :people_associated, :amount, :due_date, presence: true

  scope :today, -> { not_paids.where(due_date: Date.current) }
  scope :expireds, -> { not_paids.where("due_date < ?", Date.current) }
  scope :future, -> { not_paids.where("due_date > ?", Date.current) }
  scope :paids, -> { where(paid: true) }
  scope :not_paids, -> { where(paid: false) }
  
  STATUS = [
    ["Pagas", 1],
    ["À Pagar", 0]
  ]

  EXPIRED = [
    ["Vencidas", 1],
    ["À Vencer", 0]
  ]

  def paid?
  	self.paid
  end

  def expired?
  	self.due_date <= Date.current
  end

  def self.top_five_expired
    select('monthly_payments.*, count("people_associated_id") as quantidade')
    .expireds.group(:people_associated_id).order("quantidade DESC").limit(5)
  end

  def self.newRecurrence(obj, period, quantity)
    last_mat = obj.due_date
    (1..quantity.to_i - 1).each do |q|
      newObj = obj.dup
      newObj.due_date = last_mat + period.to_i.days
      newObj.portion = (q + 1)
      newObj.save
      last_mat = last_mat + period.to_i.days
      # last_mat = period.to_i == 30 ? (last_mat.at_beginning_of_month.next_month) : (last_mat + period.to_i.days)
    end
  end

  filterrific(
    available_filters: [
      :sorted_by,
      :search_query,
      :with_due_date_gte,
      :with_due_date_lte,
      :with_status,
      :with_expired
    ]
  )

  def self.options_for_sorted_by
  [
    ['Nome (a-z)', 'name_asc'],
    ['Nome (z-a)', 'name_desc'],
    ['Data de Vencimento (recentes primeiro)', 'due_date_desc'],
    ['Data de Vencimento (antigos primeiro)', 'due_date_asc'],
    ['Data de cadastro (recentes primeiro)', 'created_at_desc'],
    ['Data de cadastro (antigos primeiro)', 'created_at_asc']
  ]
  end
  
  scope :with_expired, lambda { |flag|
    case flag.to_i 
      when 0
        where("due_date > ?", Date.current)
      when 1
        where("due_date <= ?", Date.current)
    end        
  }  

  scope :with_status, lambda { |flag|
    where("paid = ?", [*flag])
  }  
  
  scope :with_due_date_gte, lambda { |ref_date|
    where('DATE(due_date) >= ?', ref_date.to_date)
  }

  scope :with_due_date_lte, lambda { |ref_date|
    where('DATE(due_date) <= ?', ref_date.to_date)
  }

  scope :search_query, lambda { |query|
    return nil  if query.blank?
      # condition query, parse into individual keywords
      terms = query.downcase.split(/\s+/)
      # replace "*" with "%" for wildcard searches,
      # append '%', remove duplicate '%'s
      terms = terms.map { |e|
        (e.gsub('*', '%') + '%').gsub(/%+/, '%')
      }
      # configure number of OR conditions for provision
      # of interpolation arguments. Adjust this if you
      # change the number of OR conditions.
      num_or_conditions = 1
      joins(:people_associated).where(
        terms.map {
          or_clauses = [
            "LOWER(people_associateds.name) LIKE ?"                    
          ].join(' OR ')
          "(#{ or_clauses })"
        }.join(' AND '),
        *terms.map { |e| [e] * num_or_conditions }.flatten
      )
  }
  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("monthly_payments.paid ASC,monthly_payments.created_at #{ direction }") 
    when /^due_date_/
      order("monthly_payments.paid ASC, monthly_payments.due_date #{ direction }")
    when /^name_/
      joins(:people_associated).order("monthly_payments.paid ASC, LOWER(people_associateds.name) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
end
