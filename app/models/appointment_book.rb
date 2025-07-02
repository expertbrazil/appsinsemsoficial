class AppointmentBook < ApplicationRecord
  belongs_to :professional

  has_many :appointbook_peopleassoci, dependent: :destroy, inverse_of: :appointment_book
  has_many :people_associateds, through: :appointbook_peopleassoci
end
