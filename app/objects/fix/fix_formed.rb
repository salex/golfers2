module Fix
  class FixFormed
    def initialize
      puts 'in fix_formed'
      games = Game.all.order(:id)
      games.each do |g|
        state = g.set_state
        g.formed['players'] = state[:players]
        g.formed['teams'] = state[:teams].size
        g.formed['seed_method'] = state[:seed_method]
        g.formed['makeup'] = state[:makeup]
        g.formed.delete("round") if g.formed['round'].present?      # Game.where("formed LIKE ?", "%round%").each do |g|
        g.formed
        g.save
      end
    end
  end
end

