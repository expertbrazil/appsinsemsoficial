class Subcategory < ApplicationRecord
    belongs_to :category
    has_many :bills_pays
    has_many :bills_receifes

	validates :name, presence: true

	scope :actives, -> { where(status: true)}
	
	scope :credit_categories, -> { joins(:subcategory).actives.where("subcategories.type_subcategory = ?", 1) }
	scope :debit_categories, -> { joins(:subcategory).actives.where("subcategories.type_subcategory = ?", 2) }

	
	def self.select_options_grouped

		Subcategory.actives.group(:type_subcategory).collect do |subcat|
			[ 
		      subcat.type_category_name, 
		      where(type_subcategory: subcat.type_subcategory).collect { |category| [ category.name, category.id ] }
		    ] 
		end  			

	end

	def in_use?
		bills_receifes.count > 0 || bills_pays.count > 0
	end
end
