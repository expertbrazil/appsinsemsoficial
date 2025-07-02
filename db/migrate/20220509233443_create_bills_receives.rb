class CreateBillsReceives < ActiveRecord::Migration[5.0]
  def change
    create_table :bills_receives do |t|
      t.references :people_associated, foreign_key: true
      t.references :category, foreign_key: true
      t.references :financial_account, foreign_key: true
      t.references :payment_form, foreign_key: true
      t.date :due_date
      t.text :description
      t.string :state
      t.decimal :amount, precision: 10, scale: 2, default: 0  
      t.string :n_doc
      t.date :competence_date      
      t.string :attachment
      t.integer :ocorrence, default: 0  
      t.date :deadline
      t.date :next_in
      t.string :expiration_day
      t.boolean :work_days_only, default: false
      t.boolean :paid, default: false
      t.date :paid_date
      t.boolean :stop_recurrence, default: false

      t.timestamps
    end
  end
end
