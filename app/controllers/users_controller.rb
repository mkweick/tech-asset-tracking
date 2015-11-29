class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action only: [:show, :edit, :update] { require_owner(@user) }
  before_action :require_admin, only: [:index, :new, :create, :destroy]
  
  def index
    @users = User.all.order(first_name: :asc)
  end
  
  def new
    
  end
  
  def create
    
  end
  
  def show
  
  end
  
  def edit
    
  end
  
  def update
    
  end
  
  def destroy
    
  end
  
  private
  
  def set_user
    @user = User.where('lower(username) = ?', params[:id].downcase).first
  end
  
  def require_owner(obj)
    unless obj && logged_in? && (current_user == obj || admin?)
      logged_in? ? (redirect_to user_path(current_user)) : (redirect_to root_path)
    end
  end
end