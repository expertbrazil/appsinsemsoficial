class CreateDependents < ActiveRecord::Migration[5.0]
  def change
    create_table :dependents do |t|
      t.references :people_associated, foreign_key: true
      t.string :name
      t.date :birthdate
      t.integer :degree_of_kinship

      t.timestamps
    end
  end
end
