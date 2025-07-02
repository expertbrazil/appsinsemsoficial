#encoding: utf-8
class PeopleAssociated < ApplicationRecord
  mount_base64_uploader :photo, PeopleAssociatedPhotoUploader

  acts_as_birthday :birthdate

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, #:validatable, password_length: 6..128, 
         :authentication_keys => [:login]

  validates :name, :cpf, presence: true#, :validity_card
  validates :cpf, uniqueness: true, unless: Proc.new { |p| p.cpf.blank? }
  validates :username, uniqueness: true, unless: Proc.new { |u| u.username.blank? }
  validates :number_registration, uniqueness: true
  validates :password, :confirmation => true, :length => { :within => 6..128 }, unless: lambda{ |user| user.password.blank? }  

  validate :cpf_valid?
  
  validates :email, :cell_phone1, :gender, :scholarity, :office_id, :occupation_id, :birthdate,
  :department_id, :profession, :workplace_id, :bond, presence: true, if: Proc.new { |p| !p.public_form.nil? && p.public_form }


  has_many :dependents, dependent: :destroy
  accepts_nested_attributes_for :dependents, reject_if: :all_blank, allow_destroy: true

  has_many :appointbook_peopleassoci, dependent: :destroy, inverse_of: :people_associated
  has_many :appointment_books, through: :appointbook_peopleassoci

  has_many :monthly_payments, dependent: :destroy
  has_many :bills_receifes, dependent: :destroy

  belongs_to :office
  belongs_to :occupation
  belongs_to :department
  belongs_to :workplace

  has_many :system_attachments, dependent: :destroy
  accepts_nested_attributes_for :system_attachments, reject_if: :all_blank, allow_destroy: true


  before_create :create_member_access_default
  before_create :create_token
  before_save :change_in_analysis
  
  attr_accessor :login, :public_form

    
  def cpf_valid?
     errors.add(:cpf, ("não é válido")) unless check_cpf(self.cpf)
  end


  def check_cpf(cpf=nil)
    return false if cpf.nil?

      winvalidos = %w{12345678909 11111111111 22222222222 33333333333 44444444444 55555555555 66666666666 77777777777 88888888888 99999999999 00000000000}
      wvalor = cpf.scan /[0-9]/
    if wvalor.length == 11
        unless winvalidos.member?(wvalor.join)
            wvalor = wvalor.collect{|x| x.to_i}
            wsoma = 10*wvalor[0]+9*wvalor[1]+8*wvalor[2]+7*wvalor[3]+6*wvalor[4]+5*wvalor[5]+4*wvalor[6]+3*wvalor[7]+2*wvalor[8]
            wsoma = wsoma - (11 * (wsoma/11))
            wresult1 = (wsoma == 0 or wsoma == 1) ? 0 : 11 - wsoma
            if wresult1 == wvalor[9]
              wsoma = wvalor[0]*11+wvalor[1]*10+wvalor[2]*9+wvalor[3]*8+wvalor[4]*7+wvalor[5]*6+wvalor[6]*5+wvalor[7]*4+wvalor[8]*3+wvalor[9]*2
              wsoma = wsoma - (11 * (wsoma/11))
              wresult2 = (wsoma == 0 or wsoma == 1) ? 0 : 11 - wsoma
              return true if wresult2 == wvalor[10] # CPF validado
            end
        end
    end
    return false # CPF invalidado
  end


  GENDERS = %w(Feminino Masculino Outro)
  MARITAL_STATUS = %w(Solteiro(a) Casado(a) Divorciado(a) Viúvo(a) União\ Estável)
  SCHOLARITY = [
    ["Fundamental Incompleto", 1],
    ["Fundamental Completo", 2],
    ["Ensino Médio Incompleto", 3],
    ["Ensino Médio Completo", 4],
    ["Superior Incompleto", 5],
    ["Superior Completo", 6],
    ["Pós-Graduação", 7],
    ["Mestrado", 8],
    ["Doutorado", 9]
  ]

  SITUATION = [
    ["Em Análise", 0],
    ["Ativo", 1],
    ["Inativo", 2],
    ["Licença interesse particular", 3],
    ["Licença Maternidade", 4],
  ]
  
  BOND = [
    ["Concursado", 1],
    ["Comissionado", 2],
    ["Contratado", 3],
    ["Eletivo", 4],
    ["Estagiário", 5],
    ["Aposentado", 6],
    ["Pensionista", 7]    
  ]  

  BLOOD_TYPE = [
    ["A+", 1],
    ["A-", 2],
    ["B+", 3],
    ["B-", 4],
    ["AB+", 5],
    ["AB-", 6],
    ["O+", 7],
    ["O-", 7]    
  ]

  BREED = [
    ["Branco(a)", 1],
    ["Moreno(a)", 2],
    ["Negro(a)", 3]
  ]

  scope :next_number_registration, -> { PeopleAssociated.maximum(:number_registration).to_i + 1 }
  scope :actives, -> { where(['situation = ?', 1]) }
  scope :in_analysis, -> { where(['in_analysis = ? OR situation = ?', true, 0]) }

  filterrific(
    available_filters: [
      :sorted_by,
      :birthdate_sorted_by,
      :per_date,
      :search_query,             
      :with_gender_name,
      :with_situation_ids,
      :with_bond_ids,
      :with_office_ids,
      :with_occupation_ids,
      :with_affiliate_date_gte,
      :with_affiliate_date_lte,
      :with_department_ids,
      :with_workplace_ids,
      :with_active_flag  
    ]
  )

  def self.options_for_sorted_by
    [
      ['Nome (a-z)', 'name_asc'],
      ['Nome (z-a)', 'name_desc'],
      ['Ordem de registro', 'number_registration_asc'],
      ['Ordem de matricula', 'hollering_registration_asc'],
      ['Data de cadastro (recentes primeiro)', 'created_at_desc'],
      ['Data de cadastro (antigos primeiro)', 'created_at_asc']
    ]
  end

  def self.birthdate_options_for_sorted_by
    [
      ['Nome (a-z)', 'name_asc'],
      ['Nome (z-a)', 'name_desc'],
      ['Data de aniversario (1-31)', 'birthdate_asc'],
      ['Data de aniversario (31-1)', 'birthdate_desc']
    ]
  end

  scope :with_active_flag, lambda { |flag|
    joins(:dependents).where("dependents.active = ?", [*flag])
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

  # scope :search_workplace, lambda { |query|
  #   return nil  if query.blank?
  #   # condition query, parse into individual keywords
  #   terms = query.downcase.split(/\s+/)
  #   # replace "*" with "%" for wildcard searches,
  #   # append '%', remove duplicate '%'s
  #   terms = terms.map { |e|
  #     ('%' + e.gsub('*', '%') + '%').gsub(/%+/, '%')
  #   }
  #   # configure number of OR conditions for provision
  #   # of interpolation arguments. Adjust this if you
  #   # change the number of OR conditions.
  #   num_or_conditions = 1
  #   where(
  #     terms.map {
  #       or_clauses = [
  #         "LOWER(people_associateds.workplace) LIKE ?"         
  #       ].join(' OR ')
  #       "(#{ or_clauses })"
  #     }.join(' AND '),
  #     *terms.map { |e| [e] * num_or_conditions }.flatten
  #   )
  # }


  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("people_associateds.created_at #{ direction }")
    when /^name_/
      order("LOWER(people_associateds.name) #{ direction }")
    when /^number_registration_/
      order("people_associateds.number_registration #{ direction }")  
    when /^hollering_registration_/
      order("length(people_associateds.hollering_registration), people_associateds.hollering_registration  #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :birthdate_sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^birthdate_/
      order("MONTH(people_associateds.birthdate)#{ direction }, DAY(people_associateds.birthdate)#{ direction }")
    when /^name_/
      order("LOWER(people_associateds.name) #{ direction }")
    when /^number_registration_/
      order("LOWER(people_associateds.number_registration) #{ direction }")
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  scope :with_affiliate_date_gte, lambda { |ref_date|
    where('DATE(affiliate_date) >= ?', ref_date.to_date)
  }

  scope :with_affiliate_date_lte, lambda { |ref_date|
    where('DATE(affiliate_date) <= ?', ref_date.to_date)
  }

  scope :with_gender_name, lambda { |gender_names|
    where(gender: [*gender_names])
  }  

  scope :with_situation_ids, lambda { |situation_ids|
    where(situation: [*situation_ids])
  }  

  scope :with_bond_ids, lambda { |bond_ids|
    where(bond: [*bond_ids])
  }

  scope :with_office_ids, lambda { |office_ids|
    where(office_id: [*office_ids])
  }

  scope :with_occupation_ids, lambda { |occupation_ids|
    where(occupation_id: [*occupation_ids])
  }  

  scope :with_department_ids, lambda { |department_ids|
    where(department_id: [*department_ids])
  }

  scope :with_workplace_ids, lambda { |workplace_ids|
    where(workplace_id: [*workplace_ids])
  }

  scope :per_date, lambda { |dates|
    #d = dates#.split('-')
    #PeopleAssociated.find_birthdates_for(Date.parse(dates))
    if dates.blank?
      PeopleAssociated.all
    else
      PeopleAssociated.where("MONTH(birthdate) = ?", dates)
    end
  }

  def self.find_by_cell_phone(phone)
    where('cell_phone1 = :phone OR cell_phone2 = :phone', phone: phone).first
  end

  def self.search(search)
    pa = where(["name LIKE ?", "%#{search}%"])    
    de = Dependent.where(["name LIKE ?", "%#{search}%"])

    return pa, de
  end

  def self.search_by_name(search)
    #joins(:dependents).where(["people_associateds.name LIKE ? OR dependents.name LIKE ?", "%#{search}%", "%#{search}%"])  
    pa = where(["name LIKE ?", "%#{search}%"]).map { |e| { name: "#{e.name} / #{e.phone}", id: e.id, type: "people_associated" } }    
    de = Dependent.where(["name LIKE ? AND active is true", "%#{search}%"]).map { |e| { name: "#{e.name} / #{e.people_associated.name}", id: e.id, type: "dependent" } }
    
    pa + de
  end

  def first_and_last_name
    name_array = name.split
    "#{name_array.first} #{name_array.last}"
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup

    if login = conditions.delete(:login)
      result = where(conditions.to_h).where(["lower(cpf) = :value OR lower(username) = :value", { :value => login.downcase }]).first        
    elsif conditions.has_key?(:cpf) || conditions.has_key?(:username)
      result = where(conditions.to_h).first
    end

    result
  end

  def situation_name
    SITUATION.each do |s|
      return s[0] if s[1] == self.situation.to_i
    end
  end  

  def blood_type_name
    BLOOD_TYPE.each do |s|
      return s[0] if s[1] == self.blood_type.to_i
    end
  end  

  def scholarity_name
    SCHOLARITY.each do |s|
      return s[0] if s[1] == self.scholarity.to_i
    end
  end  

  def bond_name
    BOND.each do |s|
      return s[0] if s[1] == self.bond.to_i
    end
  end

  def breed_name
    BREED.each do |s|
      return s[0] if s[1] == self.breed.to_i
    end
  end

  def calculate_age
    (Date.today - self.birthdate).to_i / 365
  end

  def full_address
    %W( #{address} #{number} #{burgh} ).join(", ")
  end

  def cell_phone_send_to_wahtsapp
    return nil if cell_phone1.blank? && cell_phone2.blank?
    _phone=''
    if !cell_phone1.blank?
      _phone = cell_phone1.gsub(/\D/, '')#.tap {|s| s.slice!(3) } #para whats remove 9 adicional
    else
      _phone = cell_phone2.gsub(/\D/, '')#.tap {|s| s.slice!(3) } #para whats remove 9 adicional
    end

    return _phone
  end

  def cell_phone_correct(phone)
    from_n = phone.split(":")[1]
    from_n.tap {|s| s.slice!(0..2) }.insert(2, '9').insert(0, '(').insert(3, ')').insert(4, ' ').insert(6, ' ').insert(11, '-') 
  end

  def degree_of_kinship_married
    dependente = dependents.where("degree_of_kinship IN (?)", [3, 4]).first
    data = if spouse.blank?
      dependente
    else
      { "name" => spouse }
    end

    OpenStruct.new(data.as_json)
  end

protected
  def create_token
    self.token = SecureRandom.urlsafe_base64(nil, false)
  end
  
  def create_member_access_default
    self.username = name.parameterize.gsub('-', '') if username.blank?
    if self.changes[:password] 
      self.password = '12345678' if password.blank?
      self.password_confirmation = '12345678' if password_confirmation.blank?
    end
  end

  def change_in_analysis
    if situation == 1  && in_analysis
      self.in_analysis =  false
    end
  end
end
