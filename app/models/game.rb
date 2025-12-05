
class Game < ApplicationRecord
  belongs_to :group
  has_many :scored_rounds
  has_many :rounds, dependent: :destroy
  has_many :players, through: :rounds
  alias_attribute :stats, :formed

  serialize :formed, coder: JSON
  serialize :par3, coder: JSON
  serialize :skins, coder: JSON

  before_save :set_player_teams

  attribute :state 

  # def stats
  #   self.formed
  # end

  def game_group
    Current.group || group
  end

  def game_course
    game_group.group_courses[self.course]
  end

  def namespace_url(action = nil)
    "/#{status.downcase}/game/#{self.id}/#{action if action.present?}"
  end

  def scheduled_url(action = nil)
    "/scheduled/game/#{self.id}/#{action if action.present?}"
  end

  def pending_url(action = nil)
    "/pending/game/#{self.id}/#{action if action.present?}"
  end

  def scored_url(action = nil)
    "/scored/game/#{self.id}/#{action if action.present?}"
  end

  def set_player_teams
    self.formed = {} if self.formed.blank?
    rnds = self.rounds
    if rnds.size.positive?
      arr = rnds.pluck(:id, :team)
      teams = arr.pluck(1).sort.uniq
      formed['players'] = arr.size
      formed['teams'] = teams.size
    else
      formed['players'] = 0
      formed['teams'] = 0
    end
  end


  def active_players
    group.active_players.where.not(id: players.pluck(:id))
  end

  def inactive_players
    group.inactive_players.where.not(id: players.pluck(:id))
  end

  def expired_players
    group.expired_players.where.not(id: players.pluck(:id))
  end

  # main player query
  def participants
    rounds.includes(:player)
  end

  def current_players
    participants.order('players.rquota DESC')
  end

  def current_team_players
    participants.order(:team, 'players.rquota DESC')
  end

  def current_players_name
    participants.order('players.name')
  end

  def set_state
    # called from scheduled or pending to help manage actions
    rnds = participants
    self.state = {
      players: rnds.size
    }.with_indifferent_access
    if state[:players].positive?
      state[:teams] = rnds.pluck(:team).uniq.sort
      state[:indiv_teams] = state[:teams].size == state[:players]
      state[:has_zero_team] =  state[:teams].include?(0)
      state[:has_scored_round] = rnds.where(type: 'ScoredRound').size.positive?
      state[:can_form] = (state[:teams] == [0]) || status == 'Scheduled'
      state[:can_reform] = !state[:can_form] && state[:has_zero_team]
      state[:can_delete] = (status != 'Scored') && ((Date.today - date) > 2)
      state[:dues] = game_group.dues
      state[:pot] = game_group.dues * state[:players]
      state[:side] = (state[:pot] / 3).round(2)
    else
      state[:can_delete] = true  # created in error
    end
    state
  end

  def update_participants(params)
    add_players(params[:add_players]) if params[:add_players].present?
    delete_players(params[:deleted]) if params[:deleted].present?
    check_tee_change(params[:tee]) if params[:tee].present?
    set_state 
    save
  end

  def add_players(add_players)
    add_players.each do |pid|
      player = game_group.players.find(pid)
      grnd = rounds.find_or_initialize_by(player_id: pid)
      grnd.date = date
      grnd.quota = player.quota
      grnd.tee = player.tee
      grnd.team = 0
      grnd.limited = player.limited  # there was a bug called limited? which return boolean
      grnd.save
    end
  end

  def delete_players(deleted_player)
    deleted_player.each do |pid|
      grnd = rounds.find_by(id: pid)
      next unless grnd.present?
      grnd.delete
    end
  end

  def check_tee_change(tees)
    tees.each do |t|
      rid, otee, ntee = t.split('.')
      next if otee == ntee

      r = rounds.find_by(id: rid)
      r.tee = ntee
      nquota =  PlayerObjects::Quota.new(r.player).tee_quota(ntee).to_struct
      r.quota = nquota.quota
      r.limited = nquota.limited
      r.save
    end
  end

  def game_teams(team = nil)
    teams = rounds.pluck(:team).uniq.sort
    results = {}
    if team.present? # just players for single team
      results[team.to_i] = current_players.where(team: team)
    else
      teams.each do |t|
        results[t] = current_players.where(team: t)
      end
    end
    results
  end

  def scorecard_teams
    teams = {}
    self.game_teams.each_pair do |team,gplayers|
      teams[team] = {players:[],header:""}.with_indifferent_access
      tquota = 0
      gplayers.each do |gp|
        tquota += gp.quota
        fl = gp.full_name.split
        initial = fl.size > 1 ? fl[0][0..0] + fl[1][0..0] : fl[0][0..1]
        quota = "#{gp.tee[0..0]}#{gp.limited.present? ? (gp.quota.to_s+'*') : gp.quota}"
        teams[team][:players] << {name: gp.name,quota:quota,initial:initial }
      end
      teams[team][:header] = "Team #{team} - Quota #{tquota} Side #{tquota/2.0} Hole #{(tquota / 18.0).round(1)}"
    end
    teams
  end


  def adjust_teams(params)
    # THIS NEEDS REFACTORED (I did)
    if params[:swap_team_1].present? && params[:swap_team_2].present?
      return swap_team_order(params[:swap_team_1], params[:swap_team_2])
      # swap teams is all that is on form, just ruturn if thats all
    end

    if params[:team].present?
      params[:team].each do |player, team|
        # was game_rounnds but was scrored by mistake, change to rounds
        rnd = rounds.find_by(id: player)
        if rnd.present? && rnd.team != team.to_i
          rnd.team = team
          rnd.save
        end
      end
    end
    # can also have tee and delete params so
    update_participants(params)
  end

  def swap_team_order(team1, team2)
    t1 = rounds.where(team: team1)
    t2 = rounds.where(team: team2)
    ok = t1.present? && t2.present?
    if ok
      t1.each { |r| r.update(team: team2) }
      t2.each { |r| r.update(team: team1) }
    end
    ok
  end

  def pay_par3s=(params)
    new_par3 = { 'good' => params[:par3][:good], 'player_good' => {} }
    if params[:par3][:in].blank? || new_par3['good'].blank?
      self.par3 = new_par3
      self.save 
      return 
    end

    params[:par3][:in].each_key do |id|
      new_par3['player_good'][id] = ''
    end
    new_par3['good'].each do |hole, pid|
      if new_par3['player_good'][pid]
        new_par3['player_good'][pid] += hole
      else
        new_par3['good'].delete(hole)
      end
    end
    self.par3 = new_par3
    side = Par3.new(self)
    side.pay_winners
    save
  end

  def pay_skins=(params)
    return if params[:skins][:good].blank?
    new_skins = { 'good' => params[:skins][:good], 'player_par' => {} }
    params[:skins][:in].each_key do |id|
      new_skins['player_par'][id] = params[:skins][:player_par][id]
    end
    self.skins = new_skins
    #call skins with game not saved but modifed
    # new copy of rounds will be fetched but noting in them used except name
    side = Skins.new(self)
    side.pay_winners
    save
  end

  def has_skins?
    skins.present? && skins['good'].present?
  end

  def has_par3?
    par3.present? && par3['good'].present?
  end


end
