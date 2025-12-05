class PasswordsController < ApplicationController
  before_action :require_user
  before_action :authenticate_user_from_session

  def show
  end

  def edit
  end

  def update
    puts "PPPPP #{user_params}"
    if current_user.update(user_params)
      redirect_to root_path, notice:"Your password has been updated successfully."
    else 
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit( 
        # :email, 
        # :username, 
        # :fullname,
        # :email, 
        :password, 
        :password_confirmation,
        :password_challenge).with_defaults(password_challenge:'')
    end

end
