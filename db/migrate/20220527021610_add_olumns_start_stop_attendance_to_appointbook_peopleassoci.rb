class AddOlumnsStartStopAttendanceToAppointbookPeopleassoci < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointbook_peopleassocis, :start_attendance, :boolean, default: false
  	add_column :appointbook_peopleassocis, :stop_attendance, :boolean, default: false
  	add_column :appointbook_peopleassocis, :description, :text
  	add_column :appointbook_peopleassocis, :has_return, :boolean, default: false
  end
end
