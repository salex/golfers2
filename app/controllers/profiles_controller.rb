class ProfilesController < ApplicationController
  before_action :require_user
  before_action :authenticate_user_from_session

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, notice:"Your profile info updated successfully."
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  def player_search
    @search_results = Current.group.auto_search(params)
    # puts "IN PLAYER SEARCH"
    if @search_results
      render template:'shared/pickr_search', layout:false
    end
  end

  def pairings_search
    @interactions = Player.pairing_search(params)
    render turbo_stream: turbo_stream.replace(
      'pairings',partial: 'pairings')
  end


  private
    def user_params
      params.require(:user).permit( 
        :email, 
        :username, 
        :fullname
      )
    end

end
