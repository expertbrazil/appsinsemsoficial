json.extract! monthly_payment, :id, :people_associated_id, :month, :amount, :amount_paid, :due_date, :pay_day, :paid, :observation, :created_at, :updated_at
json.url monthly_payment_url(monthly_payment, format: :json)
