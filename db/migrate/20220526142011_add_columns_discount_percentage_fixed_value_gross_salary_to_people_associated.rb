class AddColumnsDiscountPercentageFixedValueGrossSalaryToPeopleAssociated < ActiveRecord::Migration[5.0]
  def change
  	add_column :people_associateds, :discount_percentage, :integer, default: 0
  	add_column :people_associateds, :fixed_value, :decimal, precision: 10, scale: 2, default: 0  
  	add_column :people_associateds, :gross_salary, :decimal, precision: 10, scale: 2, default: 0  
  	add_column :people_associateds, :in_analysis, :boolean, default: false
  	add_column :people_associateds, :blood_type, :integer, default: 0
  	add_column :people_associateds, :is_allergic, :boolean, default: false
  	add_column :people_associateds, :take_controlled_medicine, :boolean, default: false
  	add_column :people_associateds, :take_controlled_medicine_description, :text
  end
end
