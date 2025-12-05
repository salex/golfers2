class Scored::GameController < ApplicationController
  # before_action :permit, except: %i[show]

  before_action :set_game #, only: %i[ show par3s skins]

  def show

    @game.method = current_group.pays if @game.method.blank?
    # vaild was to catch a game with deleted player NUsed
    valid =  true #@game.rounds.length == @game.stats[:round][:players]
    case @game.method
    when 'sides'
      if valid
        @scoring = ScoreSides.new(@game)
        render template:'scored/game/show_sides'

      else
        render template:'scored/game/invalid'
      end
    when 'places'
      if valid
        @scoring = PgaScorePlaces.new(@game)
        render template:'scored/game/show_places'
      else
        render template:'scored/game/invalid'
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
      @game.set_state
    end

  end

  def sidegame_params
    params.permit!.to_h
  end

end
