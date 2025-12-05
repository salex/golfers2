json.extract! player, :id, :group_id, :first_name, :last_name, :nickname, :use_nickname, :name, :tee, :quota, :rquota, :phone, :is_frozen, :last_played, :pin, :limited, :created_at, :updated_at
json.url player_url(player, format: :json)
