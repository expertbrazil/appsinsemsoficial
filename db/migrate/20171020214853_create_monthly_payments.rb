class CreateMonthlyPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :monthly_payments do |t|
      t.references :people_associated, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, default: 0  
      t.decimal :amount_paid, precision: 10, scale: 2, default: 0  
      t.date :due_date
      t.date :pay_day
      t.boolean :paid, default: false
      t.text :observation
      t.integer :portion

      t.timestamps
    end
  end
end
