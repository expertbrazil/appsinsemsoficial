class PaymentForm < ApplicationRecord
	has_many :bills_receifes	

	validates :name, presence: true, uniqueness: true	

	scope :actives, -> { where(status: true) }
end
