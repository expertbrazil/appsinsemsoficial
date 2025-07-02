class AddColumnWithSpecialNeedsValidateStatementActiveToDependents < ActiveRecord::Migration[5.0]
  def change
  	add_column :dependents, :with_special_needs, :boolean, default: false
  	add_column :dependents, :validate_statement, :text
  	add_column :dependents, :active, :boolean, default: true
  end
end
