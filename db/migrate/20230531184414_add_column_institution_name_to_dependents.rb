class AddColumnInstitutionNameToDependents < ActiveRecord::Migration[5.0]
  def change
  	add_column :dependents, :institution_name, :string
  end
end
