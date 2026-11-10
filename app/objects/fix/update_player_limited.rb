class Fix::UpdatePlayerLimited
  attr_accessor :group, :players, :scored_rounds

  def initialize
    puts "Starting to update player limited"
    groups = Group.all
    groups.each do |group|
      puts "I Be Initialized for #{group.name}!"
      cnt = 0
      group.players.each do |player|
        set_new_limited(player)
        cnt += 1
      end
      puts "We checked #{cnt} players for group #{group.name}"
    end
  end

  def set_new_limited(player)
    limit = PlayerObjects::LimitStatus.get(player)
    if limit != player.limited
      puts "Status Changed: current #{player.name} #{player.limited} changed #{limit}"
      player.limited = limit
      player.save
     end
  end

end