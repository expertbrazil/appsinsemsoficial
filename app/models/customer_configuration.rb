class CustomerConfiguration < ApplicationRecord
	mount_base64_uploader :logo, CustomerConfigurationUploader
	mount_base64_uploader :signature, CustomerConfigurationUploader
    
	validates :name, :address, :street, :city, :state, :cnpj, :phone, :cell_phone, :date_fundation, presence: true

	scope :actives, -> { where(status: true) }

	before_save :only_one_active

	def self.current
    	CustomerConfiguration.actives.first
  	end



protected
	def only_one_active
		CustomerConfiguration.where("id != ?", id).update_all(status: false) if status === true
	end
end