json.extract! category, :id, :subcategory_id, :type, :name, :status, :created_at, :updated_at
json.url category_url(category, format: :json)
