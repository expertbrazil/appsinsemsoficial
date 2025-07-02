json.extract! bills_pay, :id, :supplier_id, :people_associated_id, :payment_form_id, :category_id, :payroll_discount, :due_date, :description, :amount, :n_doc, :competence_date, :ocorrence, :expiration_day, :deadline, :work_days_only, :receive, :receive_date, :stop_recurrence, :state_assm, :created_at, :updated_at
json.url bills_pay_url(bills_pay, format: :json)
