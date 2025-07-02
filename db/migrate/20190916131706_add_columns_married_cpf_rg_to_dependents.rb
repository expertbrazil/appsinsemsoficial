class AddColumnsMarriedCpfRgToDependents < ActiveRecord::Migration[5.0]
  def change
  	add_column :dependents, :cpf, :string
  	add_column :dependents, :rg, :string
  	add_column :dependents, :dispatcher_organ, :string
  end
end
