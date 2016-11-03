json.extract! bulk, :id, :name, :email, :telephone, :created_at, :updated_at
json.url bulk_url(bulk, format: :json)