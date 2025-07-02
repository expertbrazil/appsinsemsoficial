class CreateSubCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :subcategories do |t|
      t.references :category, foreign_key: true      
      t.string :name
      t.string :reduced_code
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
