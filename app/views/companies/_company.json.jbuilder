json.extract! company, :id, :name, :email, :address, :number, :complement, :zipcode, :burgh, :city, :state, :phone, :benefit, :created_at, :updated_at
json.url company_url(company, format: :json)