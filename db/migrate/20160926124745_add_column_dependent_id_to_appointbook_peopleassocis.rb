class AddColumnDependentIdToAppointbookPeopleassocis < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointbook_peopleassocis, :dependent_id, :integer, foreign_key: true
  end
end
