#encoding: utf-8
class Dependent < ApplicationRecord
  belongs_to :people_associated

  has_many :appointbook_peopleassoci, dependent: :destroy, inverse_of: :dependent
  has_many :appointment_books, through: :appointbook_peopleassoci
  
  has_many :system_attachments, dependent: :destroy
  accepts_nested_attributes_for :system_attachments, reject_if: :all_blank, allow_destroy: true

  validates :username, uniqueness: true, unless: Proc.new { |u| u.username.blank? }
  validates :password, :confirmation => true, :length => { :within => 6..128 }, unless: lambda{ |user| user.password.blank? }  



  before_create :create_member_access_default

  attr_accessor :login  

  #validates :name, :birthdate, :degree_of_kinship, presence: true
  DEGREE_OF_KINSHIP = [
    ["Filho(a)", 1],
    ["Enteado(a)", 2],
    ["Esposo(a)", 3],
    ["Companheiro(a)", 4],
    ["Pai", 5],
    ["Mãe", 6],
    ["Neto(a)", 7],
    ["Irmão", 8],
    ["Irmã", 9],
    ["Avô", 10],
    ["Avó", 11],
    ["Outros", 12]
  ]

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, #:validatable, 
         :authentication_keys => [:login]    
    
  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  # use this instead of email_changed? for Rails = 5.1.x
  def will_save_change_to_email?
    false
  end

  
  scope :actives, -> {where(active: true)}
  
  filterrific(
    available_filters: [
      :sorted_by,
      :search_query,
      :with_people_associated_id,       
      :with_active_flag   
    ]
    )

  scope :with_people_associated_id, lambda { |people_associated_ids|
    where(people_associated_id: [*people_associated_ids])
  }

  scope :with_active_flag, lambda { |flag|
    where(active: [*flag])
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
    where(
      terms.map {
        or_clauses = [
          "LOWER(dependents.name) LIKE ?"
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
          order("dependents.created_at #{ direction }")
      when /^name_/
          order("LOWER(dependents.name) #{ direction }")
      else
          raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.options_for_sorted_by
    [
        ['Nome (a-z)', 'name_asc'],
        ['Nome (z-a)', 'name_desc'],
        ['Data de cadastro (recentes primeiro)', 'created_at_desc'],
        ['Data de cadastro (antigos primeiro)', 'created_at_asc']
    ]
  end


  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      result = where(conditions.to_h).where(["lower(username) = :value", { :value => login.downcase }]).first if result.nil?       
    elsif conditions.has_key?(:username)
      result = where(conditions.to_h).first
    end

    result
  end

  def first_and_last_name
    name_array = name.split
    "#{name_array.first} #{name_array.last}"
  end

  def self.find_by_cell_phone(phone)
    where('cell_phone = :phone', phone: phone).first
  end

  def degree_of_kinship_other?
    degree_of_kinship == 12
  end

  
  def degree_of_kinship_name
    DEGREE_OF_KINSHIP.each do |s|
      return s[0] if s[1] == self.degree_of_kinship.to_i
    end
  end

  def calculate_age
    (Date.today - self.birthdate).to_i / 365
  end

  def inactive!
    self.update_attribute(:active, false)
  end

  def self.inactive_benefit_expired
    actives.where('dependents.benefit_until < ?', Date.current).order(benefit_until: :asc).each do |dependent|
      dependent.inactive!
    end
  end

protected
  def create_member_access_default
    self.username = name.parameterize.gsub('-', '') if username.blank?
    if self.changes[:password] 
      self.password = '12345678' if password.blank?
      self.password_confirmation = '12345678' if password_confirmation.blank?
    end
  end
end
