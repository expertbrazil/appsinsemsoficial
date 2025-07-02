class RemoveColumnDepartmentToPatrimonies < ActiveRecord::Migration[5.0]
  def change
  	remove_foreign_key :patrimonies, :departments
  	remove_reference :patrimonies, :department, index: true
  end
end
