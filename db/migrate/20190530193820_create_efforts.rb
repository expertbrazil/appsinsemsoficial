class CreateEfforts < ActiveRecord::Migration[5.0]
  def change
    create_table :efforts do |t|
      t.string :name
      t.boolean :to_describe

      t.timestamps
    end
  end
end
