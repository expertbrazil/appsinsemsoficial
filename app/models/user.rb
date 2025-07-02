class User < ApplicationRecord
	# Include default devise modules. Others available are:
  	# :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, #:registerable,
         :recoverable, :rememberable, :trackable, :validatable

	has_many :role_users, :dependent => :destroy
  	has_many :roles, :through => :role_users   

  	belongs_to :professional

  	validates :username, :email, presence: true      
  	validates :username, uniqueness: true     

    default_scope  { order(active: :desc, name: :asc) }

  	has_settings do |s|
    	s.key :company, :defaults => { name: "Sindicato", address: "", street: "", city: "", state: "", 
    								   cnpj: "", phone: "", cell_phone: "", date_fundation: "", president: 'Presidente', 
    								   ficha: '<p>Autorizo o desconto em folha de pagamento do percentual de 2% (dois por cento) referente à mensalidade sindical em favor do NomeDoSindicato.</p>' }
    	s.key :dashboard, :defaults => {   :theme => 'blue', :view => 'monthly', :filter => false, }    	
  	end


    def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
   
      login = conditions.delete(:username)
      result = where(conditions).where(["lower(username) = :value OR lower(email) = :value", { value: login.strip.downcase}]).first

      result if result && result.active       
    end

	
	def allowed_to?(action, options={}, &block)
	    if options[:global]
	      # Admin users are always authorized
	      # authorize if user has at least one role that has this permission
	      roles = self.roles.to_a.flatten.uniq

	      roles.any? {|role|
	        role.allowed_to?(action)
	      }
	    else
	      false
	    end
	end

  	# Is the user allowed to do the specified action on any project?
  	# See allowed_to? for the actions and valid options.
  	def allowed_to_globally?(action, options, &block)
    	allowed_to?(action, options.reverse_merge(:global => true), &block)
  	end

  	def admin?
    	roles.map(&:name).map(&:upcase).include?("ADMIN")
  	end
end
