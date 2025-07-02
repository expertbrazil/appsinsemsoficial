class CreateFinancialAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :financial_accounts do |t|
      t.string :name
      t.boolean :status, default: true

      t.timestamps
    end
  end
end
