class AddColumnOtherManualToDependents < ActiveRecord::Migration[5.0]
  def change
  	add_column :dependents, :other_manual, :string
  end
end
