class AddColumnCellPhoneToCompany < ActiveRecord::Migration[5.0]
  def change
  	add_column :companies, :cell_phone, :string
  end
end
