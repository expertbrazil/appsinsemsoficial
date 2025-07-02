class CreatePaymentForms < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_forms do |t|
      t.string :name
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
