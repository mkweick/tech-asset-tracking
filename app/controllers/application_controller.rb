class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?, :admin?
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def logged_in?
    !!current_user
  end
  
  def admin?
    current_user.admin
  end
  
  def login(user)
    session[:user_id] = user.id
  end
  
  def logout
    session.delete(:user_id)
  end
  
  def log_in_message
    flash.alert = "Access Denied. Please log in."
    redirect_to root_path
  end
  
  def access_denied
    flash.alert = "You do not have permissions to access that"
    redirect_to user_path(current_user)
  end
  
  def require_user
    log_in_message unless logged_in?
  end
  
  def require_owner(obj)
    if logged_in?
      access_denied unless obj && (current_user == obj.user || admin?)
    else
      log_in_message
    end
  end
  
  def require_admin
    logged_in? ? (access_denied unless admin?) : (log_in_message)
  end
end