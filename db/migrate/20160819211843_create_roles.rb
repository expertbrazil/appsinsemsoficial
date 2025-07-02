class CreateRoles < ActiveRecord::Migration[5.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.text :permissions
      t.integer :position
      t.boolean :assignable
      t.integer :builtin

      t.timestamps
    end
  end
end
