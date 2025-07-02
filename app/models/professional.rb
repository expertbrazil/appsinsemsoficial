class Professional < ApplicationRecord
    after_create :create_user_access
    before_destroy :destroy_user_access

    has_one :appointment_book
    has_one :user
    
    validates :name, :cpf, :type_function, presence: true
    default_scope  { order(active: :desc, name: :asc) }


    scope :actives, -> { where(active: true)}

	TYPES = [
    	["Advogado(a)", 1],
    	["Fisioterapeuta", 2],
    	["Massoterapeuta", 3],    
    	["Médico(a) clínico geral", 4],    
    	["Médico(a) dermatologista", 5],    
    	["Médico(a) ginecologista", 6],    
    	["Psicólogo", 7],    
    	["Dentista", 8],    
    	["Acupunturista", 9],    
  	]


    def create_appointment_book
        AppointmentBook.find_or_create_by(professional_id: self.id)
    end

    def destroy_appointment_book
        app_book = AppointmentBook.where(professional_id: self.id).first
        app_book.destroy if app_book
    end

    def lawyer?
        type_function == 1
    end

    def create_user_access
        pwd_cpf = self.cpf.parameterize.gsub("-", "")        
        username_email = self.name.parameterize.gsub("-", "")
        User.create(name: self.name, username: username_email, email: "#{username_email}@exemple.com", password: pwd_cpf, password_confirmation: pwd_cpf, professional_id: self.id)
    end

    def destroy_user_access
        self.user.destroy if self.user
    end

    def function_name
        TYPES.each do |s|
            return s[0] if s[1] == self.type_function.to_i
        end
    end
end
