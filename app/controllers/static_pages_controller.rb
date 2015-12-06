class StaticPagesController < ApplicationController
  before_action :require_admin, only: [:asset_admin]
  
  def home
    if logged_in?
      admin? ? (redirect_to users_path) : (redirect_to user_path(current_user))
    end
  end
  
  def asset_admin; end
end