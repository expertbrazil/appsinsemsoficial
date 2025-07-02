class CreateInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :inventories do |t|
      t.string :description
      t.string :unit
      t.integer :minimum_balance
      t.integer :opening_balance

      t.timestamps
    end
  end
end
