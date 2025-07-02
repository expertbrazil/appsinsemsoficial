class InventoryMovement < ApplicationRecord
	belongs_to :inventory

	TYPES = [
		["Entrada", 1],
		["Saida", 2]    
	]

	validates :type_balance, presence: true
	validates :balance, presence: true

	scope :created_at_desc, -> { order(created_at: :desc) }
	scope :entry, -> { where( type_balance: 1 ).created_at_desc }
	scope :output, -> { where( type_balance: 2 ).created_at_desc }

	def entry?
		type_balance == 1
	end
	
	def type_balance_name
    	TYPES.each do |s|
      		return s[0] if s[1] == self.type_balance.to_i
    	end
  	end
end
