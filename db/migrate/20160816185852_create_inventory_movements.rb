class CreateInventoryMovements < ActiveRecord::Migration[5.0]
  def change
    create_table :inventory_movements do |t|
      t.references :inventory, foreign_key: true
      t.integer :type_balance
      t.integer :balance
      t.decimal :amount

      t.timestamps
    end
  end
end
