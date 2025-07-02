class CreateSuppliers < ActiveRecord::Migration[5.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
