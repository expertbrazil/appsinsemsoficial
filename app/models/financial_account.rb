class FinancialAccount < ApplicationRecord
	has_many :bills_receifes

	validates :name, presence: true, uniqueness: true	

	scope :actives, -> { where(status: true) }
	scope :inactives, -> { where(status: false) }
end