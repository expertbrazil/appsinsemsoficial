json.extract! bank_account, :id, :name, :agency, :account_number, :cedente, :cedente_doc, :cedente_address, :variacao, :aceite, :carteira, :convenio, :instrucao_juros, :default_bank, :layout, :created_at, :updated_at
json.url bank_account_url(bank_account, format: :json)
