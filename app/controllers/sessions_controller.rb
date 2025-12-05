class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate_by(email:params[:email].downcase, password: params[:password])
      login user 
      redirect_to root_path, notice: "You have signed in successfully."
    elsif user = User.authenticate_by(username:params[:email], password: params[:password])
      login user 
      redirect_to root_path, notice: "You have signed in successfully."
    else
      flash[:alert] = "Invalid email or password." 
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout(current_user)
  end
end
