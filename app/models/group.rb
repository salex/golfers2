class Group < ApplicationRecord

  has_many :players, :dependent => :destroy
  has_many :games, :dependent => :destroy
  has_many :rounds, through: :games
  has_many :users, :dependent => :destroy
  # has_many :posts, :dependent => :destroy
  # validates :name, presence: true, :uniqueness => {:scope => [:club_id, :name]}

  serialize :settings, coder: JSON

  after_initialize :set_attributes

  attribute :group_courses
  # lets just set all attributes to settings values 
  # will be cast to class if coming from form update
  # if you add/remove a setting, add/remove an attribute with class 
  #   and add to default settings 

  attribute :par_in, :string, default: "444444444"
  attribute :par_out, :string, default: "444444444"
  attribute :welcome, :text, default: "Welcome to the #{self.name}"
  attribute :alert, :text, default: ""
  attribute :notice, :text, default: ""
  attribute :tee_time, :string
  attribute :play_days, :string
  attribute :dues, :integer
  attribute :skins_dues, :integer
  attribute :par3_dues, :integer
  attribute :other_dues, :integer
  attribute :truncate_quota, :boolean
  attribute :pay, :string
  attribute :limit_new_player, :boolean
  attribute :limit_rounds, :integer
  attribute :limit_points, :integer
  attribute :limit_new_tee, :boolean
  attribute :limit_new_tee_rounds, :integer
  attribute :limit_new_tee_points, :integer
  attribute :limit_frozen_player, :boolean
  attribute :limit_frozen_points, :integer
  attribute :limit_inactive_player, :boolean
  attribute :limit_inactive_days, :integer
  attribute :limit_inactive_rounds, :integer
  attribute :limit_inactive_points, :integer
  attribute :sanitize_first_round, :boolean
  attribute :trim_months, :integer
  attribute :rounds_used, :integer
  attribute :use_hi_lo_rule, :boolean
  attribute :default_stats_rounds, :integer
  attribute :use_keyboard_scoring, :boolean
  attribute :default_in_sidegames, :boolean
  attribute :use_autoscroll, :boolean
  attribute :score_place_dist, :string
  attribute :score_place_perc, :integer
  attribute :default_course, :string



  def set_attributes
    if self.settings.blank?
      # new record, set settings from default options
      self.settings = self.default_settings
    elsif self.settings.keys != self.default_settings.keys 
      # something changed in default setting or settings
      # sync settings - add new key/value or delete old keys"
      self.default_settings.each do |k,v|
        if !self.settings.has_key?(k)
          settings[k] = v
        end
      end
      self.settings.each do |k,v|
        if !self.default_settings.has_key?(k)
          settings.delete(k)
        end
      end
      # save group because something changed
      self.save #unless self.new_record?
    end
    self.settings.each do |k,v|
      # set attributes to settings
      self.send("#{k.to_sym}=", v)
      # equivalent to self.key = v 
      # ex self.dues = 6
    end
    self.parse_courses #unless self.new_record?

  end

  
  def default_settings
    # default settings control valid setting
    # if you add or remove a key
    #   add or remove the attribute
    # only used on new/create and for its keys which point to an attribute
    # changed key to string to match json serialization
    {"par_in"=>"444444444",
     "par_out"=>"444444444",
     "welcome"=>"Welcome to Test",
     "alert"=>"",
     "notice"=>"",
     "tee_time"=>"9:30am",
     "play_days"=>"m w f",
     "dues"=>8,
     "skins_dues"=>2,
     "par3_dues"=>2,
     "other_dues"=>0,
     "truncate_quota"=>true,
     "pay"=>"",
     "limit_new_player"=>false,
     "limit_rounds"=>2,
     "limit_points"=>2,
     "limit_new_tee"=>false,
     "limit_new_tee_rounds"=>1,
     "limit_new_tee_points"=>2,
     "limit_frozen_player"=>false,
     "limit_frozen_points"=>2,
     "limit_inactive_player"=>false,
     "limit_inactive_days"=>180,
     "limit_inactive_rounds"=>1,
     "limit_inactive_points"=>2,
     "sanitize_first_round"=>false,
     "trim_months"=>18,
     "rounds_used"=>10,
     "use_hi_lo_rule"=>false,
     "default_stats_rounds"=>100,
     "use_keyboard_scoring"=>false,
     "default_in_sidegames"=>true,
     "use_autoscroll"=>true,
     "score_place_dist"=>"mid",
     "score_place_perc"=>50,
     "default_course"=>"Home"
    }
  end

  def update_group(params)
    self.assign_attributes(params)
      # updates record without saving, just set attributes
      # assign_attributes is a rails method
    self.default_settings.each do |k,v|
      # now take the set attributes and update to serialized settings
      # just using default_setting keys to point to setting key
      self.settings[k] = self.send(k.to_sym) 
    end
    self.save 
  end

  def parse_courses
    if self.courses.blank?
      # set a parse_able string with key and values
      self.courses = "Home::par_in=#{self.par_in}:par_out=#{self.par_out}:tees=#{self.tees}"
    end
    course_hash = {}
    courses_arr =self.courses.split(',') 
    courses_arr.each do |c|
      # puts "COURSE #{self.name} #{c}"
      kv = c.split("::")
      course_hash[kv[0]] = {}
      elems = kv[1].split(":")
      elems.each do |e|
        i = e.split("=")
        course_hash[kv[0]][i[0]] = i[1]
      end
    end
    self.group_courses = course_hash
  end

  def expired_players
    self.players.where_assoc_not_exists(:rounds).order(:name)
  end

  def active_players(ago=90)
    active_date = Date.today - ago.days
    active = self.players.where_assoc_exists(:rounds).where(Player.arel_table[:last_played].gteq(active_date)).or(new_players).order(:name)
  end

  def inactive_players(ago=90)
    active_date = Date.today - ago.days
    inactive = self.players.where_assoc_exists(:rounds).where(Player.arel_table[:last_played].lt(active_date)).order(:name)
  end

  def new_players
    self.players.where(last_played:Date.today).where_assoc_not_exists(:rounds)
  end

  def home_events
    self.games.where(status:%w(Scheduled Pending)).order(:date).reverse_order
  end

  def group_color
    c = %w{green red blue purple orange}[self.id % 5]
    puts "GC = #{c} #{self.id}"
    "bg-#{c}-500"
  end

  def auto_search(params)
    # for stimulus-autocomple used in playerSearch controller
    # puts "AUTOSEARCH #{params}"
    k = params.keys.first
    n = params[k]
    t = Player.arel_table
    player_ids = self.players.where(t[:first_name].matches("%#{n}%"))
    .or(self.players.where(t[:last_name].matches("%#{n}%")))
    .or(self.players.where(t[:nickname].matches("%#{n}%"))).order(:name).pluck(:name,:id)
  end

  def trim_rounds
    # lets get rid of all rounds and events that are over options[:trim_months] months old
    exp_date = Date.today - self.trim_months.months
    games = self.games.where(Game.arel_table[:date].lt(exp_date)).includes(:rounds)
    if games.present?
      games.destroy_all
      recompute_group_quotas
    end
  end

  def recompute_group_quotas
    self.players.each do |player|
      player.recompute_quota
    end
  end

end
