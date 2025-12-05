json.extract! game, :id, :group_id, :date, :status, :method, :scoring, :par3, :skins, :created_at, :updated_at
json.url game_url(game, format: :json)
