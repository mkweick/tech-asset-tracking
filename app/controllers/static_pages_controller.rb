class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      admin? ? (redirect_to users_path) : (redirect_to user_path(current_user))
    end
  end
end