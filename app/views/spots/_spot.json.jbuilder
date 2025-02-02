json.extract! spot, :id, :name, :prefecture_id, :address, :url, :body, :user_id, :created_at, :updated_at
json.url spot_url(spot, format: :json)
