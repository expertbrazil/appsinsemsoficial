class CreateTypeIncorporations < ActiveRecord::Migration[5.0]
  def change
    create_table :type_incorporations do |t|
      t.string :name
      t.boolean :to_describe

      t.timestamps
    end
  end
end
