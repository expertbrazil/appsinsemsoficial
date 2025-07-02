class BillsPay < ApplicationRecord
  include AASM
  
  belongs_to :supplier
  belongs_to :people_associated
  belongs_to :payment_form
  belongs_to :category
  belongs_to :bank_account
  has_one :bills_receife#, dependent: :destroy
  has_many :system_attachments, dependent: :destroy
  accepts_nested_attributes_for :system_attachments, reject_if: :all_blank, allow_destroy: true


  validates :supplier, :category, :ocorrence, :amount, :payment_form,  presence: true
  validates :people_associated,  presence: true, if: Proc.new { |u| u.payroll_discount }
  validate :validate_format_date

  before_save :next_due
  before_save :check_payroll_discount


  scope :overdues, -> { where("DATE(due_date) < ?", Date.current )}
  scope :pendings, -> { where(state_assm: :pending)}
  scope :paids, -> { where(state_assm: :paided)}


   OCORRENCE = [
    ["Única", 1, 1],
    ["Semanal", 2, 7],
    ["Quinzenal", 3, 15],
    ["Mensal", 4, 30],
    ["Bimestral", 5, 60],
    ["Trimestral", 6, 90],
    ["Semestral", 7, 180],
    ["Anual", 8, 365]
  ]
 
  STATES = [["Pendente", "pending", { color: "info" }], 
            ["Pago", 'paided', { color: "success" }], 
            ["Em Atraso", "overdued", { color: "warning" }], 
            ["Cancelada", 'canceled', { color: "danger" }]
           ]


filterrific(
    available_filters: [
      :sorted_by,
      :per_date,
      :search_query,             
      :with_gender_name,
      :with_created_at_gte,
      :with_created_at_lte,
      :with_due_date_gte,
      :with_due_date_lte,
      :with_supplier_ids,
      :with_people_associated_ids,
      :with_category_ids,
      :with_situation_flag  
    ]
  )

  def self.options_for_sorted_by
    [
      ['Nome (a-z)', 'name_asc'],
      ['Nome (z-a)', 'name_desc'],
      ['Data de cadastro (recentes primeiro)', 'created_at_desc'],
      ['Data de cadastro (antigos primeiro)', 'created_at_asc']
    ]
  end

  def self.options_for_grouped_by
    #Category.credit_subcategories.collect {|category| [category.name, category.id]}
    [
      ['Plano de Contas', 'category_id'],
      ['Fornecedor', 'supplier_id']
    ]
  end


   scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^due_date_/
      order("bills_pays.due_date #{ direction }")
    when /^created_at_/
      order("bills_pays.created_at #{ direction }")
    when /^name_/
      order("LOWER(suppliers.name) #{ direction }")
    when /^category_name_/
      order("LOWER(categories.name) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }


  scope :with_situation_flag, lambda { |flag|
    where("state_assm = ?", [*flag])
  }  

  scope :with_category_ids, lambda { |category_ids|
    category = Category.find(category_ids)

    if category.descendant_ids.blank?
      where("category_id = ?", [*category_ids])
    else
      with_childrens = category.descendant_ids.push(category.id)
      where("category_id IN (?)", [*with_childrens])
    end
  } 

  scope :with_supplier_ids, lambda { |with_supplier_ids|
    where("supplier_id = ?", [*with_supplier_ids])
  }  

  scope :with_created_at_gte, lambda { |ref_date|
    @interval = ref_date.split('-').collect { |dt| dt.strip }  
    # where("created_at BETWEEN ? AND ?", @interval[0], @interval[1]) if @interval[0].to_date != Date.current
    where(created_at:  @interval[0].to_date.beginning_of_day.. @interval[1].to_date.end_of_day) if @interval[0].to_date != Date.current

    # where('DATE(created_at) >= ?', ref_date.to_date)
  }

  scope :with_created_at_lte, lambda { |ref_date|
    where('DATE(created_at) <= ?', ref_date.to_date)
  }  

  scope :with_due_date_gte, lambda { |ref_date|
    # where('DATE(due_date) >= ?', ref_date.to_date)
      @interval = ref_date.split('-').collect { |dt| dt.strip }  
    # where("created_at BETWEEN ? AND ?", @interval[0], @interval[1]) if @interval[0].to_date != Date.current
    where(due_date:  @interval[0].to_date.beginning_of_day.. @interval[1].to_date.end_of_day) if @interval[0].to_date != Date.current
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
      ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 1
    where(
      terms.map {
        or_clauses = [
          "LOWER(people_associateds.name) LIKE ?"               
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  aasm column: :state_assm do 
    state :pending, initial: true
    state :paided
    state :overdued
    state :canceled

    # de pendente para recebido
    event :paid do
      transitions from: :pending, to: :paided
    end
    
    # de Pendente para em atraso
    event :overdue do
      transitions from: :pending, to: :overdued
    end

    # de Pendente para cancelado
    event :cancel do
      transitions from: :pending, to: :canceled
    end

    # voltar para pendente
    event :negotiate do
      transitions from: [:received, :overdued, :canceled], to: :pending
    end
    
  end


  def self.check_due_date_to_change_overdued
    pendings.overdues.each do |bp_overdue|
      bp_overdue.overdue!
    end
  end

  def state_name
    STATES.each do |s|
      return [s[0], s[2]] if s[1] == self.state_assm
    end
  end

  def ocorrence_day
    OCORRENCE.each do |s|
      return s[2] if s[1] == self.ocorrence.to_i
    end
  end

  def ocorrence_name
      OCORRENCE.each do |s|
          return s[0] if s[1] == self.ocorrence.to_i
      end
  end   

  def has_recurrence?
    ocorrence.to_i > 1 && !stop_recurrence
  end

  def check_payroll_discount
    if payroll_discount
      # gera conta a receber
    else
      # exclui conta a receber
    end
  end


  #####
  # Adicionar próximo vencimento
  ##### 
  def next_due
    
    ####
    # se ocorrencia > 1 (!unica)
    ####
    if ocorrence.to_i > 1 && !stop_recurrence
      
      ####
      # se a ocorrencia for mensal/bimestral/trimestral/semestral e anual 
      ####
      if [4, 5, 6, 7, 8].include?(ocorrence.to_i)        
        
        ####
        # se possuir um dia de vencimento gera a partir dele
        ####
        self.next_in = if !expiration_day.blank?
            next_date = due_date + ocorrence_day.days
            Date.new(next_date.year, next_date.month, expiration_day.to_i)    
          else
            due_date + ocorrence_day.days
          end        
      else
        
        ####
        # semanal ou quinzenal
        ####
        self.next_in = due_date + ocorrence_day.days 
      end

    end

    valid_next_in?
    valid_work_days? if !next_in.nil?
  end


  ####
  # Verificar se a conta deve ser adicionada somente em dias da semana
  ####
  def valid_work_days?
    if work_days_only
      self.next_in = case next_in.wday
          when 0 #domingo
            next_in + 1.day
          when 6 #sabado
            next_in + 2.day
        end
    end
  end

  ####
  # Valida proximo vencimento se possuir uma data limite
  ####
  def valid_next_in?
    
    ####
    # se tiver uma data limite
    # verifica se o proximo vencimento esta dentro do limite
    ####
    if !next_in.nil? && !deadline.blank?
      self.next_in = nil if next_in > deadline 
    end
  end 

  def valid_date?(date)
    DateTime.parse(date.to_s)
    true
  rescue ArgumentError
    false
  end

  
  def validate_format_date
    if !due_date.blank?      
      errors.add(:due_date, " Inválido") if !valid_date?(due_date)
    else
      errors.add(:due_date, " Inválido")
    end 

    if !competence_date.blank?
      errors.add(:competence_date, " Inválida") if !valid_date?(competence_date)        
    else
      errors.add(:competence_date, " Inválida")
    end 

    if !deadline.blank?
      errors.add(:deadline, " Inválida") if !valid_date?(deadline)        
    end 
  end
end

