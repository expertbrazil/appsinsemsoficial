class AddColumnsToPeopleAssociateds < ActiveRecord::Migration[5.0]
  def change
  	add_column :people_associateds, :dispatcher_organ, :string
  	add_column :people_associateds, :father_mother, :boolean, default: false
  	add_column :people_associateds, :start_registration, :date
  	add_column :people_associateds, :office_id, :integer, foreign_key: true
  	add_column :people_associateds, :occupation_id, :integer, foreign_key: true
  end
end
