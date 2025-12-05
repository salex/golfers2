json.extract! user, :id, :group_id, :fullname, :username, :email, :role, :permits, :created_at, :updated_at
json.url user_url(user, format: :json)
