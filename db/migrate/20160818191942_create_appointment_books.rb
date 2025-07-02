class CreateAppointmentBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :appointment_books do |t|
      t.references :professional, foreign_key: true

      t.timestamps
    end
  end
end
