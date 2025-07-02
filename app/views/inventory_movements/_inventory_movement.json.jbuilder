json.extract! inventory_movement, :id, :inventory_id, :type, :balance, :amount, :created_at, :updated_at
json.url inventory_movement_url(inventory_movement, format: :json)