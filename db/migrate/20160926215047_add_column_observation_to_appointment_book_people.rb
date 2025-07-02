class AddColumnObservationToAppointmentBookPeople < ActiveRecord::Migration[5.0]
  def change
  	add_column :appointbook_peopleassocis, :confirmed, :boolean
  	add_column :appointbook_peopleassocis, :observation, :text
  end
end
