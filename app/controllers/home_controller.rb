class HomeController < ApplicationController
  def index
    if current_group.present?
      @notice = Notice.where(Notice.arel_table[:due_date].gt(Date.today))
      render template: 'home/group'
    else
      render template: 'home/groups'
    end
  end

  def groups
    render template: "home/groups"
  end

  def test
    render template: "home/test"
  end

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

  def redirect
    redirect_group(params[:path])
    # puts "ingroup #{@group} #{helpers.inspect_session}"    
    if @group.present?
      reset_session
      Current.group = @group
      session[:group_id] = @group.id
      session[:fullname] = "Visitor"
      session[:expires] = Time.now + 15.minutes
      cookies[:group_id] = {value: @group.id, expires: Time.now + 15.minutes}
      params[:format] = 'html'
      redirect_to root_path
    else
      cant_do_that(" -> #{params[:path]}")
    end
  end

  private

  def redirect_group(path)
    @group = Group.find_by(Group.arel_table[:name].matches("%#{path}"))
    # puts "inRedirect #{if @group.present? ? @group.name : "none"}"
    # return @group
  end

end
