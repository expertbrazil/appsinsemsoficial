class CreateCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :reduced_code
      t.integer :parent_id
      t.integer :type_subcategory, default: 1
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
