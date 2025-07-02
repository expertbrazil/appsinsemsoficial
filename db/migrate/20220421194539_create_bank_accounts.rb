class CreateBankAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.string :agency
      t.string :account_number
      t.string :cedente
      t.string :cedente_doc
      t.string :cedente_address
      t.string :variacao
      t.string :aceite, default: "N"
      t.string :carteira
      t.string :convenio
      t.string :instrucao_juros
      t.boolean :default_bank, default: false   
      t.integer :layout

      t.timestamps
    end
  end
end