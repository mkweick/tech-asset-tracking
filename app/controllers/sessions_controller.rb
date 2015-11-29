class SessionsController < ApplicationController
   
  def new
    redirect_to user_path(current_user) if logged_in?
  end
    
  def create
    user = User.where('lower(username) = ?', params[:username].downcase).first
    
    if user && user.authenticate(params[:password])
      login(user)
      redirect_to user_path(user)
    else
      flash.now.alert = "You've entered an incorrect username and password"
      render 'new'
    end
  end
  
  def destroy
    logout
    flash.notice = "Successfully logged out"
    redirect_to root_path
  end
  
  private
  
  
end