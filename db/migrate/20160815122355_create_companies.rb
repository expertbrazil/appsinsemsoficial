class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :address
      t.integer :number
      t.string :complement
      t.string :zipcode
      t.string :burgh
      t.string :city
      t.string :state
      t.string :phone
      t.text :benefit

      t.timestamps
    end
  end
end
