class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user, :logged_in?
  
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
  
  def require_owner(obj)
    unless obj && logged_in? && (current_user == obj.user || admin?)
      logged_in? ? (redirect_to user_path(current_user)) : (redirect_to root_path)
    end
  end
  
  def require_admin
    unless logged_in? && admin?
      logged_in? ? (redirect_to user_path(current_user)) : (redirect_to root_path)
    end
  end
end