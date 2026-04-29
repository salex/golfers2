=begin 
  lost track on what this does
  This is a new version that imports all Games, Players and
    Rounds from ptgolf7
  ptgolf7 will be update latest dump of ptgolf7 database
  and use it's Convert module to create json files
  The only thing used in the Convert module is:
    new_conversion.rb
  which creates json file in 
    app/objects/convert/json/new
  Those file are then copied to the lib directory in golfers2 and imported 
  to replace players, games and rounds

  players, games and rounds will be deleted first
  then new version will be imported
=end

class ImportGolfers
  def initialize
    puts "IT GOT HERE"
    delete_models
    import_players
    import_games
    import_rounds
  end

  def delete_models
    Round.delete_all
    Game.delete_all
    Player.delete_all
  end

  def fix_game_stats
    Game.all.each{|g|
      g.formed = g.formed['round']
      g.save
    }
  end

  def import_players
    json = File.read(Rails.root.join('lib','golfers','set_players.json'))
    records = JSON.parse(json)
    records.each{|i|
      Player.create(i)
    }
    puts "Players Size #{Player.all.size} "
  end
  
  def import_games
    json = File.read(Rails.root.join('lib','golfers','set_games.json'))
    records = JSON.parse(json)
    records.each{|i|
      Game.create(i)
      # i.formed = i.formed['round']
      # i.save

    }
    puts "Games Size #{records.size} "
  end

  def import_rounds
    json = File.read(Rails.root.join('lib','golfers','set_rounds.json'))
    records = JSON.parse(json)
    cnt = 0
    records.each_with_index{|r,i|
      if r.blank?
        puts "No Rounds #{i}"
      else         # r is an array of rounds
        r.each{|nr|
          unless nr.class == Array
            Round.create(nr)
            cnt += 1
          end
        }
      end
    }
    puts "GameRound #{cnt} were created"
  end

end
