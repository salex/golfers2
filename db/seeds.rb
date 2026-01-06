# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# THIS IS AN INITIAL IMPORT OF THE LOCAL VERSION OF GOLFERS
# PROBABLY CAN USED IT UPDATE NEW PLAYERS, GAMES AND ROUNDS
# json = File.read(Rails.root.join('db','golfers','set_golfers.json'))
# golfers = JSON.parse(json)
# puts golfers.size
# golfers.each{|i|
#   Golfer.create(i)
# }


# json = File.read(Rails.root.join('db','golfers','set_stashes.json'))
# stashes = JSON.parse(json)
# stashes.each{|i|
#   Stash.create(i)
# }

# json = File.read(Rails.root.join('db','golfers','set_groups.json'))
# groups = JSON.parse(json)
# groups.each{|i|
#   Group.create(i)
# }

# json = File.read(Rails.root.join('db','golfers','set_users.json'))
# users = JSON.parse(json)
# users.each{|i|
#   User.create(i)
# }

# json = File.read(Rails.root.join('db','golfers','set_players.json'))
# players = JSON.parse(json)
# players.each{|i|
#   Player.create(i)
# }

# json = File.read(Rails.root.join('db','golfers','set_games.json'))
# games = JSON.parse(json)
# games.each{|i|
#   Game.create(i)
# }

# json = File.read(Rails.root.join('db','golfers','set_rounds.json'))
# rounds = JSON.parse(json)
# rounds.each{|i|
#   Round.create(i)
# }

# # get_golfers
# get_stashes
# get_groups
# get_users
# get_players
# get_games
# get_rounds
