class Scheduled::GameController < ApplicationController
  before_action :set_game

  def show

  end

  def update_players
    # puts "PARAMS #{params.inspect}"
    @game = current_group.games.find(params[:id])
    respond_to do |format|
      if @game.update_participants(params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace('scheduler', partial: '/scheduled/game/set') }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def set
    # @players = current_group.players.order(:name)
    @game = current_group.games.find(params[:id])
    @game.set_state if @game.present?
  end


  def toggle_pays
    @game = current_group.games.find(params[:id])
    @game.method = params[:method].downcase
    @game.save
    @show = true

    render turbo_stream: turbo_stream.replace('toggle_pays', partial: '/shared/theader')
    # redirect_to @game.namespace_url, notice: 'Game pay method changed'
  end

  def change_course
    if params[:course].present?
      params.permit!
      @game.course = params[:course]
      @game.save
      redirect_to    scheduled_game_path(@game), notice:"Game Course changed to #{params[:course]}"
    else
      redirect_to    scheduled_game_path(@game), alert:"Can't change Course to #{params[:course]}"
    end
  end

  def change_pay
    if params[:pay].present?
      params.permit!
      @game.method = params[:pay]
      @game.save
      redirect_to    scheduled_game_path(@game), notice:"Game Pay Method changed to #{params[:pay]}"
    else
      redirect_to    scheduled_game_path(@game), alert:"Can't change Pay Method to #{params[:pay]}"
    end
  end


  def form_teams
    # gets the form teams form
    @game = current_group.games.find(params[:id])
    @game.set_state if @game.present?
    @teams = ScheduledGame::TeamOptions.new(@game.state[:players])
  end

  def update_teams
    # responds to update teams form
    @game  = GameScheduled.find_by(id:params[:id])
    ok = @game.form_teams(params[:team_makeup], params[:seed_method])
    if ok 
      redirect_to @game.namespace_url, notice:'Teams have been formed'
    else
      redirect_to games_path, alert:'something screwed up(makeup or method), teams not formed'
    end
  end

  private

  def set_game

    @game = current_group && current_group.games.find_by(id:params[:id])
    if @game.blank?
      cant_do_that(' - Scheduled game not found') 
    # elsif !current_user.can?(:update,:game)
    #   cant_do_that(' - Not Permitted') 
    else
      @game.set_state
    end

  end




end
