class CreateBillsPays < ActiveRecord::Migration[5.0]
  def change
    create_table :bills_pays do |t|
      t.references :supplier, foreign_key: true
      t.references :people_associated, foreign_key: true
      t.references :payment_form, foreign_key: true
      t.references :category, foreign_key: true
      t.boolean :payroll_discount
      t.date :due_date
      t.text :description
      t.decimal :amount, precision: 10, scale: 2, default: 0  
      t.string :n_doc
      t.date :competence_date
      t.integer :ocorrence, default: 0  
      t.integer :expiration_day
      t.date :deadline
      t.boolean :work_days_only, default: false
      t.boolean :receive, default: false
      t.date :receive_date
      t.boolean :stop_recurrence, default: false
      t.string :state_assm
      t.date :next_in

      t.timestamps
    end
  end
end