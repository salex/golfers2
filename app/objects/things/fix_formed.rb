module Things
  class FixFormed
    def initialize
      puts 'in fix_formed'
      Game.all.each do |g|
        g.formed.delete("round")
        g.set_formed
        g.save
      end
    end
  end
end

