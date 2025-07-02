class AddColumnIsStudentToDependents < ActiveRecord::Migration[5.0]
  def change
  	add_column :dependents, :is_student, :string
  end
end
