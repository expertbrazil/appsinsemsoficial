class AddColumnDepartmentAndSpouseToPeopleAssociated < ActiveRecord::Migration[5.0]
  def change
  	add_reference :people_associateds, :department, index: true
  	add_column :people_associateds, :spouse, :string
  end
end
