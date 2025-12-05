class GameScheduled < Game

  def form_teams(makeup,form_method)
    teams = ScheduledGame::FormTeams.new(self.rounds.size,makeup,form_method).teams
    # puts "WHAT TEAMS #{teams}"
    return false if teams.blank?  
    if makeup == 'individuals' || makeup == 'assigned'
      scheduled_rounds = self.current_players_name
    elsif form_method == :least_paired
      scheduled_rounds = ScheduledGame::LeastPaired.new(self).scheduled_rounds
    else
      scheduled_rounds = self.current_players
    end
    if scheduled_rounds.present?
      t = 0
      teams.each do |a|
        t += 1 unless makeup == 'assigned'
        a.each do |m|
          scheduled_rounds[m-1].team = t
          scheduled_rounds[m-1].save
        end
      end
      self.formed = {} #if self.formed.nil?
      self.formed['makeup'] = makeup
      self.formed['seed_method'] = form_method
      self.status = 'Pending'
      self.save
    else
      false
    end
  end
  
end
