# THIS IS NOT USED. Think a refactor replaced with PlayerObjects::PlayerQuotas
class PlayerObjects::PlayerQuotas < ApplicationService
  attr_reader :player, :group, :scored_rounds, :tees 
  attr_accessor :rounds_used
  # , :player_quota, :raw_quota, :last_played, :dropped, :totals, :limited

  def initialize(player)
    @player = player
    @group = Current.group || player.group
    @scored_rounds = ScoredRound.where(player_id:@player.id).reverse_order
    @tees = @scored_rounds.pluck(:tee).uniq
    @rounds_used = group.rounds_used
  end

  def compute_quotas
    tee_rounds = self.tee_rounds
  end

  private

  def tee_rounds
    tee_rounds = {}
    # First get all rounds by tee
    tees.each do |t|
      sr = scored_rounds.where(tee:t)
      tee_rounds[t]={}
      tee_rounds[t][:last_played] = sr[0].date
      tee_rounds[t][:tee] = t
      tee_rounds[t][:totals] = scored_rounds.where(tee:t)
        .limit(rounds_used + 1).pluck(:total)
      quota = (tee_rounds[t][:totals].sum.to_f / tee_rounds[t][:totals].size).round(2)
      tee_rounds[t][:raw_quota] = quota
      tee_rounds[t][:quota] = (quota + 0.25).to_i
    end
    # Then get all tee
    ar = scored_rounds
    tee_rounds['Base'] = {}
    tee_rounds['Base'][:last_played] = ar[0].date
    tee_rounds['Base'][:tee] = "All"
    tee_rounds['Base'][:totals] = scored_rounds.limit(rounds_used + 1).pluck(:total)
    quota = (tee_rounds['Base'][:totals].sum.to_f / tee_rounds['Base'][:totals].size).round(2)
    tee_rounds['Base'][:raw_quota] = quota
    tee_rounds['Base'][:quota] = (quota + 0.25).to_i
    return tee_rounds
  end

end