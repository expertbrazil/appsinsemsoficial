class AddColumnCanceledToAppointbookPeopleassocis < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointbook_peopleassocis, :canceled, :boolean, default: false
  end
end
