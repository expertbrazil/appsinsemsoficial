json.extract! payment_form, :id, :name, :status, :created_at, :updated_at
json.url payment_form_url(payment_form, format: :json)
