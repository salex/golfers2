class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :session_expired

  def session_expired
    if current_user.present? && session[:expires].present?
      expire_time = Time.parse(session[:expires]) || Time.now
      session_time_left = (expire_time - Time.now).to_i
      unless session_time_left > 0
        logout(current_user)
      else
        session[:expires] = Time.now + 60.minutes
        # because I have code that checks Current.user/group and visit
        Current.user = current_user
        Current.group = Group.find_by(id:session[:group_id])
      end
    elsif current_group.present? && session[:expires].present?
      expire_time = Time.parse(session[:expires]) || Time.now
      session_time_left = (expire_time - Time.now).to_i
      unless session_time_left > 0
        logout(nil)
      else
        session[:expires] = Time.now + 15.minutes
      end
    end
  end

  def can?(crud,model)
    current_user && current_user.can?(crud,model)
  end
  helper_method :can?

  def is_manager?
    current_user && current_user.is_manager? # && current_user.group_id == current_group.id
  end
  helper_method :is_manager?

  def is_trustee?
    current_user && current_user.is_trustee? # && current_user.group_id == current_group.id
  end
  helper_method :is_trustee?

  def is_super?
    current_user && current_user.is_super?
  end
  helper_method :is_super?


  private

  def require_login
    if current_user.nil? 
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :require_login

  def require_manager
    unless current_user && current_user.is_manager?
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end
  helper_method :is_manager?

  def require_user
    unless current_user
      redirect_to root_url, alert: "I'm sorry. I can't - or You can't do that."
    end
  end

  def cant_do_that(msg=nil)
    redirect_to root_url, alert: "Sorry! I or You can't do that. #{msg}"
  end
  helper_method :cant_do_that

  
  def current_user 
    Current.user ||= authenticate_user_from_session
  end
  helper_method :current_user

  def current_group 
    # visit
    Current.group ||= Group.find_by(id:session[:group_id])
  end
  helper_method :current_group

  
  def authenticate_user_from_session
   u =  User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?

  def login(user)
    Current.user = user
    reset_session
    session[:group_id] = user.group_id
    session[:user_id] = user.id
    session[:fullname] = user.fullname == "Unknown" ? user.username : user.fullname
    session[:expires] = Time.now + 60.minutes
    Current.group = Current.user.group
  end

  def logout(user)
    Current.user = nil 
    reset_session
    redirect_to root_path, notice: "You have been logged out."
  end

end
