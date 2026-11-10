class Scored::GameController < ApplicationController
  # before_action :permit, except: %i[show]

  before_action :set_game #, only: %i[ show par3s skins]

  def show
    # this should be removed after we fix formed
    # it fixes game.formed
    # removed the @game.save 
      # if @game.formed['round'].present? || @game.formed['players'] == 0
      #   @game.set_formed
      #   if @game.changed? && @game.changed.include?("formed")
      #     if @game.formed["round"].present?
      #       @game.formed.delete("round")
      #     end
      #     # @game.save
      #   end
      # end
    # if @game.formed['players'] == 0
    #   puts "GAME  #{@game.formed['round']}"
    #   @game.formed = @game.formed['round']
    #   puts "FIXed #{@game.formed}"
    #   @game.save if @game.changed?
    # end
    # if @game.formed['round'].present? && self.formed['players'] == 0
    #   @game.set_state
    #   self.formed['players'] = self.state[:players]
    #   self.formed['teams'] = self.state[:teams].size
    #   self.formed['makeup'] = self.state[:makeup]
    #   self.formed['seed_method'] = self.state[:seed_method]
    # else
    #   shit=crap
    # end

    @game.method = current_group.pay if @game.method.blank?
    # vaild was to catch a game with deleted player NUsed
    valid = @game.rounds.length == @game.formed['players']
    case @game.method
    when 'sides'
      if valid
        @scoring = ScoreSides.new(@game)
        render template:'scored/game/show_sides'

      else
        redirect_to root_path, alert:'scored/game/invalid'
      end
    when 'places'
      if valid
        @scoring = PgaScorePlaces.new(@game)
        render template:'scored/game/show_places'
      else
        redirect_to root_path, alert:'scored/game/invalid '
      end
    end
  end

  def par3s
  end

  def skins
  end

  def rescore_teams
    render template:'games/pending/score_teams'
  end

  def update_skins
    pp = sidegame_params
    @game.pay_skins = pp
    redirect_to @game.namespace_url, notice: "Skins Side Games Updated"
  end

  def update_par3s
    pp = sidegame_params
    @game.pay_par3s = pp
    redirect_to @game.namespace_url, notice: "Par3 Side Games Updated"
  end

  private

  # def permit
  #   cant_do_that(' - Not Authorized') unless current_user && can?(:update,:game)
  # end

  def set_game
    @game = current_group && current_group.games.find_by(id:params[:id], status:'Scored')
    if @game.blank?
      cant_do_that(' - Scored game not found') 
    else
      @game.set_formed
    end

  end

  def sidegame_params
    params.permit!.to_h
  end

end
