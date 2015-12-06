class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action only: [:show, :edit, :update] { require_owner(@user) }
  before_action :require_admin, only: [:index, :new, :create, :destroy]
  before_action :set_filter_sort, only: [:index]
  before_action :set_pages_offset, only: [:index]
  
  def index
    @users = User.select("id, username, last_name, first_name, admin,  
                          (SELECT COUNT(*) FROM fixed_assignments AS fa 
                              WHERE users.id = fa.user_id) AS fa_count, 
                          (SELECT COUNT(*) FROM unfixed_assignments AS ufa 
                              WHERE users.id = ufa.user_id) AS ufa_count")
                 .group(:id)
                 .order("#{@filter} #{@sort}")
                 .offset(@offset)
                 .limit(User::PAGE_OFFSET)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create(user_params)
    
    if @user.save
      flash.notice = "#{@user.first_name} #{@user.last_name} 
                      created successfully"
      redirect_to users_path
    else
      render 'new'
    end
  end
  
  def show
    @fixed_assets = @user.fixed_assets
                         .select("ctg.name, fixed_assets.id, mfg_name, 
                                  model_num, serial_num")
                         .joins("JOIN categories AS ctg 
                                 ON fixed_assets.category_id = ctg.id")
                         .order("ctg.name asc")
    
    @unfixed_assets = @user.unfixed_assets
                           .select("ctg.name, unfixed_assets.id, mfg_name, 
                                    model_num, serial_num")
                           .joins("JOIN categories AS ctg 
                                   ON unfixed_assets.category_id = ctg.id")
                           .order("ctg.name asc")
  end
  
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
    if params[:asset_type]
      if params[:asset_type] == 'fixed'
        @user.fixed_assets.delete(params[:asset_id])
        flash.notice = "Fixed asset successfully unassigned from 
                        #{@user.first_name} #{@user.last_name}"
      else
        @user.unfixed_assets.delete(params[:asset_id])
        flash.notice = "Loaned asset successfully checked in for  
                        #{@user.first_name} #{@user.last_name}"
      end
      redirect_to user_path(@user)
    else
      if @user.destroy
        flash.notice = "#{@user.first_name} #{@user.last_name} 
                        successfully deleted"
      else
        flash.alert = "#{@user.first_name} #{@user.last_name} can't be deleted. 
                       Fixed or Unfixed assets still exist."
      end
      redirect_to users_path
    end
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
      when 'fn' then @filter = 'first_name'
      when 'fa' then @filter = 'fa_count'
      when 'ufa' then @filter = 'ufa_count'
      when 'admin' then @filter = 'admin'
      else @filter = 'last_name'
    end
    
    params[:sort] == 'd' ? (@sort = 'desc') : (@sort = 'asc')
  end
  
  def set_pages_offset
    if params[:page]
      @offset = (params[:page].to_i - 1) * User::PAGE_OFFSET
    else
      @offset = 0
    end
    
    @pages = (User.count / User::PAGE_OFFSET.to_f).ceil
  end
end