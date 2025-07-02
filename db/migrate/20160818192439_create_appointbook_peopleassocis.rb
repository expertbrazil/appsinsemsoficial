class CreateAppointbookPeopleassocis < ActiveRecord::Migration[5.0]
  def change
    create_table :appointbook_peopleassocis do |t|
      t.references :appointment_book, foreign_key: true
      t.references :people_associated, foreign_key: true
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.text :situation

      t.timestamps
    end
  end
end
