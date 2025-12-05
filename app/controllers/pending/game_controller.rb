class Pending::GameController < ApplicationController
  before_action :set_game

  def show
  end

  def adjust_teams
  end

  def swap_teams
  end

  def print_score_card
    @teams = @game.scorecard_teams
  end
  def print_score_cardp
    @teams = @game.scorecard_teams
  end
  def print_places_scard
    @teams = @game.scorecard_teams
  end
  def print_places_scardh
    @teams = @game.scorecard_teams
  end




  def score_card
    if @game.formed['makeup'] == "individuals" || @game.formed['seed_method'] == 'blind_draw'
      pdf =  Pdf::IndvScoreCard.new(@game)
    else
      pdf =  Pdf::ScoreCard.new(@game)
    end
    send_data pdf.render, filename: "score_card",
      type: "application/pdf",
      disposition: "inline"
  end


  def score_cardp
    if @game.formed['makeup'] == "individuals" || @game.formed['seed_method'] == 'blind_draw'
      pdf =  Pdf::ScoreCardi.new(@game)
    else
      pdf =  Pdf::ScoreCardp.new(@game)
    end

    # pdf =  Pdf::ScoreCardp.new(@game)
    send_data pdf.render, filename: "score_card",
      type: "application/pdf",
      disposition: "inline"
  end

  def indv_score_card
    pdf =  Pdf::IndvScoreCard.new(@game)
    send_data pdf.render, filename: "score_card",
      type: "application/pdf",
      disposition: "inline"
  end


  def update_teams

    respond_to do |format|
      if @game.adjust_teams(params)
        # Games::Teams::Form.assign_teams(@game)
        format.html { redirect_to @game.namespace_url, notice: 'Game Teams successfully assigned.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { redirect_to root_path }
      end
    end
  end

  def score_teams
  end

  def update_scores
    respond_to do |format|
      if ScoreRounds.new(@game,participant_params)
        flash.now[:notice] = 'Scoring Game Teams was successfull.'
        format.html { redirect_to @game.namespace_url, notice: 'Score Game Teams was successfull.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { redirect_to score_teams_path(@event), alert: "Score Events Teams was NOT successfull: #{@event.errors.messages}"}
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_game
    @game = current_group && GamePending.find_by(id:params[:id],group_id:current_group.id)
    if @game.blank?
      cant_do_that(' - Pending game not found') 
    else
      @game.set_state
    end

  end

  def participant_params
    params.permit!.to_h
  end


end
