json.extract! bills_receife, :id, :people_associated_id, :category_id, :financial_account_id, :payment_form_id, :due_date, :description, :amount, :n_doc, :competence_date, :attachment, :ocorrence, :deadline, :expiration_day, :work_days_only, :created_at, :updated_at
json.url bills_receife_url(bills_receife, format: :json)
