json.extract! customer_configuration, :id, :name, :address, :city, :state, :cnpj, :phone, :cell_phone, :date_fundation, :logo, :street, :president, :ficha, :created_at, :updated_at
json.url customer_configuration_url(customer_configuration, format: :json)
