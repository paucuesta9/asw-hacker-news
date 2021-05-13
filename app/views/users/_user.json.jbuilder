json.extract! user, :id, :username, :about
json.url user_url(user, format: :json)
