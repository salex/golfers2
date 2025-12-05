class AppsController < ApplicationController

  def score_sheet
    pdf =  Pdf::ScoreSheet.new
    send_data pdf.render, filename: "score_sheet",
      type: "application/pdf",
      disposition: "inline"
  end

  def places_sheet
    if params[:col].present?
      render template: 'apps/places_sheet'
    else
      render template: 'apps/places_sheet1'
    end
  end

  def payouts
    render template: 'apps/payouts/payouts'
  end

  def reset
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('refresh', 
          partial: 'apps/payouts/stats_refresh',
          locals:{dues:params[:stats][:dues],
          meth:params[:stats][:game],
          doll:params[:stats][:doll],
          perc:params[:stats][:perc]})}
      format.html { render :template => 'apps/payouts/payouts'}
    end

  end

  def about
    render template: 'apps/payouts/about'
  end
  def deals
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'apps/payouts/deals')
  end
  def pga
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'apps/payouts/pga')
  end
  def rate
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'apps/payouts/rate')
  end
  def scoring
    render turbo_stream: turbo_stream.replace(
      'content',
      partial: 'apps/payouts/scoring')
  end


end
