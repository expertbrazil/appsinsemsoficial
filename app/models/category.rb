class Category < ApplicationRecord
	has_closure_tree dependent: :destroy

	has_many :subcategories, dependent: :destroy
	has_many :bills_pays 
	has_many :bills_receifes 

	validates :name, :type_subcategory, presence: true

	TYPES = [
    	["Receita", 1],
    	["Despesa", 2]
  	]  	

	scope :actives, -> { where(status: true) }
	scope :inactives, -> { where(status: false) }

	scope :credit_subcategories, -> { where(type_subcategory: 1)}
	scope :debit_subcategories, -> { where(type_subcategory: 2)}


	def type_category_name
	    TYPES.each do |s|
	      return s[0] if s[1] == self.type_subcategory.to_i
	    end
	end  

	def credit?
		type_subcategory == 1
	end

	def debit?
		type_subcategory == 2
	end

	def in_use?
		subcategories.count > 0
	end

	def self.teste
		json = { data: [] }
		select_options_grouped_by_credit_categories[:data].each do |tes|
			json[:data] << {
				id: tes[:id],
				title: tes[:title],
				subs: tes[:subs]
			}
		end

		json
	end

	# receitas
	def self.select_options_grouped_by_credit_categories

		# Category.actives.credit_subcategories.collect do |subcat|
		# 	[ 
		#       subcat.name, 
		#       credit_categories.where(subcategory_id: subcat.id).collect { |category| [ category.name, category.id ] }
		#     ] 
		# end  

		actives.credit_subcategories.hash_tree

		 # roots = actives.credit_subcategories.roots

		 # json = { data: [] }
		 # roots.each do |root|
		 # 	json_densc = descendants_options(root.descendants) if !root.descendants.blank?

		 # 	json_root = { id: root.id, title: root.name.strip, subs: json_densc }
		 # 	json[:data] << json_root
		 # end

		 # json
	end


	#despesas
	def self.select_options_grouped_by_dedit_categories
	 #  Category.actives.debit_subcategories.collect do |subcat|
		# 	[ 
		#       subcat.name, 
		#       debit_categories.where(subcategory_id: subcat.id).collect { |category| [ category.name, category.id ] }
		#     ] 
		# end 

		actives.debit_subcategories.hash_tree

		# roots = actives.debit_subcategories.roots

		#  json = { data: [] }
		#  roots.each do |root|
		#  	json_densc = descendants_options(root.descendants) if !root.descendants.blank?

		#  	json_root = { id: root.id, title: root.name.strip, subs: json_densc }
		#  	json[:data] << json_root
		#  end

		#  json
	end


	 def self.descendants_options(items)
	 	json_subs = []
	 	items.each do |item|
	 		if !item.descendants.blank?
	 			json_densc = descendants_options(item.descendants) 
				json_subs << { id: item.id, title: item.name.strip, subs: json_densc }
			else
				json_subs << { id: item.id, title: item.name.strip  }
			end
	 	end
	    
	    json_subs
	end
end
