json.extract! appointment_book, :id, :professional_id, :created_at, :updated_at
json.url appointment_book_url(appointment_book, format: :json)