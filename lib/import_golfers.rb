=begin 
  lost track on what this does
  golfers,stashes, groups and users are on imported once
  the remain unchanged execpt for changes made after the initial 
  commit

  Players, games and rounds are deleted and replaced

=end

class ImportGolfers
  def initialize
    puts "IT GOT HERE"
    delete_models
    import_players
    import_games
    import_rounds
    # fix_game_stats
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
