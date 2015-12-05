class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action only: [:show, :edit, :update] { require_owner(@user) }
  before_action :require_admin, only: [:index, :new, :create, :destroy]
  before_action :set_filter_sort, only: [:index]
  before_action :set_pages_offset, only: [:index]
  
  def index
    if @filter == :fixed_assets
      @users = User.select("users.*, COUNT(f_asn.user_id) f_assets_count")
                   .joins("LEFT JOIN fixed_assignments AS f_asn
                           ON users.id = f_asn.user_id")
                   .group("users.id")
                   .order("f_assets_count #{@sort.to_s}")
                   .offset(@offset)
                   .limit(User::PAGE_OFFSET)
    elsif @filter == :unfixed_assets
      @users = User.select("users.*, COUNT(uf_asn.user_id) uf_assets_count")
                   .joins("LEFT JOIN unfixed_assignments AS uf_asn 
                           ON users.id = uf_asn.user_id")
                   .group("users.id")
                   .order("uf_assets_count #{@sort.to_s}")
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
        flash.notice = "Fixed asset successfully deleted from 
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
      when "fixed-assets" then @filter = :fixed_assets
      when "unfixed-assets" then @filter = :unfixed_assets
      when "admin" then @filter = :admin
      else @filter = :last_name
    end
    
    params[:sort] == "desc" ? (@sort = :desc) : (@sort = :asc)
  end
  
  def set_pages_offset
    if params[:page]
      @offset = (params[:page].to_i - 1) * User::PAGE_OFFSET
    else
      @offset = 0
    end
    
    @pages = (User.all.size / User::PAGE_OFFSET.to_f).ceil
  end
end