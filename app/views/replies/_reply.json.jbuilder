json.extract! reply, :id, :text, :user_id, :parent_id, :created_at, :updated_at
json.url reply_url(reply, format: :json)
