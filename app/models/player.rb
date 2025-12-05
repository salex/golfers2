class Player < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :group
  has_many :scored_rounds
  has_many :rounds, dependent: :destroy
  has_many :games, through: :rounds

  def self.pairing_search(params,numb=30)
    subject = Player.find_by(id:params[:subject])
    return false if subject.blank?
    sname = subject.name
    mname = []
    marray = []
    subject_rounds = subject.scored_rounds.order(date: :desc).limit(numb).pluck(:game_id,:team,:date)
    results = {subject:sname,mates:[],mname:[]}.with_indifferent_access
    params[:mates].each do |m|
      mate = Player.find(m)
      results[:mname] << mate.name
      m_rounds = mate.scored_rounds.order(date: :desc).limit(numb).pluck(:game_id,:team,:date)
      intersection = subject_rounds & m_rounds
      results[:mates] << intersection
    end
    return results
  end


  def quota_limited
    if limited?
      "<strong>#{self.quota}*</strong>".html_safe
    else
      quota
    end
  end
  def rquota_limited
    if limited?
      "<strong>#{self.rquota}*</strong>".html_safe
    else
      rquota
    end
  end

  def limited?(tee=nil)
    tee.blank? ? self.limited.present? : PlayerObjects::LimitStatus.get(self,tee)
  end

  def recompute_quota(game_date = nil)
    # game_date is only set if coming from Games::ScoreRounds, pass on to set_quota
    quotas = PlayerObjects::Quota.new(self).tee_quota.to_struct
    set_quota(quotas, game_date)
  end

  def set_quota(quotas, game_date)
    if quotas.totals.blank?
      # get base quota. will set player.quota if there are rounds
      quotas = PlayerObjects::Quota.new(self).tee_quota('Base').to_struct 
    end
    # remembers there is no tee set, uses primary tee
    #TODO is there any reason for this if statement? If nothing changed should not do anything
    # if quotas.totals.present? || game_date.present? || quotas.tee == "Base"
      # update last_played if game_date && played from different tee
    self.quota = quotas.quota
    self.last_played = game_date.present? && game_date > self.last_played ? game_date : quotas.last_played
    self.rquota = quotas.rquota
    self.limited = quotas.limited
    # will rollback if quota.nii?
    self.save if self.changed?
    # end
  end

  def format_phone
    number_to_phone(self.phone,delimiter:'.') if self.phone.present?
  end

  def unformat_phone
    self.phone = self.phone.gsub(/[^\d]/,"") if self.phone.present?
  end

  def quality_stats(limit=100)
    #TODO should be based on group stats setting
    grp = self.group
    soy = Date.today.beginning_of_year
    # sr = self.scored_rounds.where(ScoredRound.arel_table[:date].gteq(soy))
    sr = self.scored_rounds.order(:date).reverse_order.limit(limit)
    qs = {}
    [:quality,:skins,:par3,:other].each do |what|
      rnds = sr.where.not(what => nil) #.order(:date).reverse_order
      qs[what] = method_stats(what,rnds,grp)
    end
    qs
  end

  def pt_rank(limit_rounds=180)
    grp = Current.group || self.group
    sr = self.scored_rounds.where.not(quality:nil).order(:date).reverse_order.limit(limit_rounds)
    number_rounds = sr.size
    won = sr.pluck(:quality).sum
    dues = grp.dues * number_rounds
    balance = (won - dues).round(2)
    perc = dues > 0 ? (number_rounds * won / dues).round(3) : 0.0
    avg =  number_rounds > 0 ? (won / number_rounds).round(2) : 0.0
    [self.name,number_rounds,won,dues,balance,perc,avg]

  end

  def method_stats(method,rounds,grp)
    # rounds = sr.where.not(method => nil)
    number_rounds = rounds.size
    won = rounds.pluck(method).sum
    if method == :quality
      dues = grp.dues * number_rounds
    else
      dues = grp.send("#{method.to_s}_dues") * number_rounds
    end
    balance = (won - dues).round(2)
    perc = dues > 0 ? (number_rounds * won / dues).round(3) : 0.0
    avg =  number_rounds > 0 ? (won / number_rounds).round(2) : 0.0
    [self.name,number_rounds,won,dues,balance,perc,avg]
  end




  

end
