class CreateHeritageGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :heritage_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
