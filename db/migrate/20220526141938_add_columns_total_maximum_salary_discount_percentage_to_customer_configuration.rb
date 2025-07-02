class AddColumnsTotalMaximumSalaryDiscountPercentageToCustomerConfiguration < ActiveRecord::Migration[5.0]
  def change
  	add_column :customer_configurations, :total_maximum_salary, :decimal, precision: 10, scale: 2, default: 0  
  	add_column :customer_configurations, :discount_percentage, :integer, default: 0
  end
end