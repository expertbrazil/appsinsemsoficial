class CreatePatrimonies < ActiveRecord::Migration[5.0]
  def change
    create_table :patrimonies do |t|
      t.references :department, foreign_key: true
      t.string :name
      t.text :description
      t.integer :quantity
      t.date :date_of_acquisition
      t.decimal :amount
      t.integer :patrimony_number
      t.boolean :active, default: true
      
      t.timestamps
    end
  end
end
