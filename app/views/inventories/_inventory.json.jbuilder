json.extract! inventory, :id, :description, :unit, :minimum_balance, :opening_balance, :created_at, :updated_at
json.url inventory_url(inventory, format: :json)