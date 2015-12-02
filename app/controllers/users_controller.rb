class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action only: [:show, :edit, :update] { require_owner(@user) }
  before_action :require_admin, only: [:index, :new, :create, :destroy]
  before_action :set_filter_sort, only: [:index]
  before_action :set_pages_offset, only: [:index]
  
  def index
    if @filter == :fixed_assets
      @users = User.select("users.*,
                            COUNT(fixed_assignments.user_id) fixed_assets_count")
                   .joins("LEFT JOIN fixed_assignments ON 
                                     users.id = fixed_assignments.user_id")
                   .group("users.id")
                   .order("fixed_assets_count #{@sort.to_s}")
                   .offset(@offset)
                   .limit(User::PAGE_OFFSET)
    elsif @filter == :unfixed_assets
      @users = User.select("users.*,
                            COUNT(unfixed_assignments.user_id) unfixed_assets_count")
                   .joins("LEFT JOIN unfixed_assignments ON 
                                     users.id = unfixed_assignments.user_id")
                   .group("users.id")
                   .order("unfixed_assets_count #{@sort.to_s}")
                   .offset(@offset)
                   .limit(User::PAGE_OFFSET)
    else
      @users = User.all
                   .order(@filter => @sort)
                   .offset(@offset)
                   .limit(User::PAGE_OFFSET)
    end
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create(user_params)
    
    if @user.save
      flash.notice = "#{@user.first_name} #{@user.last_name} created successfully"
      redirect_to users_path
    else
      render 'new'
    end
  end
  
  def show; end
  
  def edit; end
  
  def update
    if @user.update(user_params)
      flash.notice = "Profile was update successfully"
      current_user.admin ? (redirect_to users_path):(redirect_to user_path @user)
    else
      @user.reload
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash.notice = "#{@user.first_name} #{@user.last_name} successfully deleted"
    redirect_to users_path
  end
  
  private
  
  def user_params
    params.require(:user).permit(:username, :first_name, :last_name, :email,
                                 :password, :password_confirmation, :admin)
  end
  
  def set_user
    @user = User.where('lower(username) = ?', params[:id]).first
  end
  
  def require_owner(obj)
    if logged_in?
      access_denied unless obj && (current_user == obj || admin?)
    else
      log_in_message
    end
  end
  
  def set_filter_sort
    case params[:filter]
      when "fixed-assets" then @filter = :fixed_assets
      when "unfixed-assets" then @filter = :unfixed_assets
      when "admin" then @filter = :admin
      else @filter = :last_name
    end
    params[:sort] == "desc" ? (@sort = :desc) : (@sort = :asc)
  end
  
  def set_pages_offset
    params[:page] ? (@offset = (params[:page].to_i - 1) * User::PAGE_OFFSET) : (@offset = 0)
    @pages = (User.all.size / User::PAGE_OFFSET.to_f).ceil
  end
end