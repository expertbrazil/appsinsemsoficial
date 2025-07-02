class AddColumnShowedToAppointbookPeopleassocis < ActiveRecord::Migration[5.0]
  def change
  	 add_column :appointbook_peopleassocis, :showed, :boolean, default: false
  end
end
