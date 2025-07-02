class AddColumnSidToAppointbookPeopleassocis < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointbook_peopleassocis, :sid, :string
  end
end
