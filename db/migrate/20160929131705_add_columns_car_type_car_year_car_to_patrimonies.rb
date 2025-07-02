class AddColumnsCarTypeCarYearCarToPatrimonies < ActiveRecord::Migration[5.0]
  def change
  	add_column :patrimonies, :car, :boolean
  	add_column :patrimonies, :type_car, :string
  	add_column :patrimonies, :year_car, :string
  end
end
