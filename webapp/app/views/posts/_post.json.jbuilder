json.extract! post, :id, :title, :url, :text, :created_at, :updated_at, :points, :typePost
json.url post_url(post, format: :json)
