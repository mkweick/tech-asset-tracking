class UnfixedAssetsController < ApplicationController
  before_action :require_user, only: [:check_out]
  before_action :require_admin, except: [:check_in, :check_out]
  before_action :set_ufa, except: [:index, :new, :create, :show]
  before_action :set_ufa_user, only: [:destroy]
  before_action :set_uf_asn, only: [:check_in]
  before_action only: [:check_in] { require_owner(@uf_asn) }
  before_action :set_filter_sort, only: [:index]
  before_action :set_pages_offset, only: [:index]
  before_action :set_user, only: [:check_in]
  
  def index
    @ufas = UnfixedAsset.select("ctg.name AS ctg_name, mfg_name, model_num, 
                                 serial_num, purchase_date, users.username AS username,
                                 users.last_name || ', ' || users.first_name AS assigned")
                        .joins("LEFT JOIN categories AS ctg 
                                ON unfixed_assets.category_id = ctg.id")
                        .joins("LEFT JOIN unfixed_assignments AS ufa_asn 
                                ON unfixed_assets.id = ufa_asn.unfixed_asset_id")
                        .joins("LEFT JOIN users ON ufa_asn.user_id = users.id")
                        .order("#{@filter} #{@sort}")
                        .offset(@offset)
                        .limit(UnfixedAsset::PAGE_OFFSET)
  end
  
  def new
    @ufa = UnfixedAsset.new
  end
  
  def create
    @ufa = UnfixedAsset.create(ufa_params)
    
    if @ufa.save
      flash.notice = "Unfixed Asset successfully created"
      redirect_to unfixed_assets_path
    else
      render 'new'
    end
  end
  
  def edit; end
  
  def update
    if @ufa.update(ufa_params)
      flash.notice = "Unfixed Asset successfully updated"
      redirect_to unfixed_assets_path
    else
      @ufa.reload
      render 'edit'
    end
  end
  
  def destroy
    if @ufa.destroy
      flash.notice = "Unfixed Asset (serial# #{ @ufa.serial_num }) 
                      successfully deleted"
    else
      flash.alert = "Unfixed Asset (serial# #{ @ufa.serial_num }) can't 
                     be deleted. Asset still asigned to 
                     #{ view_context.link_to @user.first_name + " " + 
                                             @user.last_name, user_path(@user),
                                             class: "ks-red-light" }"
    end
    redirect_to unfixed_assets_path
  end
  
  def check_in
    if @user && admin?
      @user.unfixed_assets.delete(@ufa)
      flash.notice = "Loaned asset sucessfully checked in for 
                      #{@user.first_name} #{@user.last_name}"
      redirect_to user_path(@user)
    else
      current_user.unfixed_assets.delete(@ufa)
      flash.notice = "Loaned asset sucessfully checked in"
      redirect_to user_path(current_user)
    end
  end
  
  def check_out
    current_user.unfixed_assets << UnfixedAsset.find(@ufa)
    flash.notice = "Loaned asset sucessfully checked out. Return within 1 week"
    redirect_to user_path(current_user)
  end
  
  private
  
  def ufa_params
    params.require(:unfixed_asset).permit(:category_id, :mfg_name, :model_num,
                                      :serial_num, :description, :purchase_date)
  end
  
  def set_ufa
    @ufa = UnfixedAsset.where('lower(serial_num) = ?', params[:id].downcase)
                                                                       .first
  end
  
  def set_uf_asn
    @uf_asn = UnfixedAsset.find_by(serial_num: params[:id]).unfixed_assignment
  end
  
  def set_ufa_user
    @user = @ufa.user
  end
  
  def set_filter_sort
    case params[:filter]
      when 'mfg' then @filter = 'mfg_name'
      when 'mn' then @filter = 'model_num'
      when 'sn' then @filter = 'serial_num'
      when 'pd' then @filter = 'purchase_date'
      when 'asn' then @filter = 'assigned'
      else @filter = 'ctg_name'
    end
    
    params[:sort] == 'd' ? (@sort = 'desc') : (@sort = 'asc')
  end
  
  def set_pages_offset
    if params[:page]
      @offset = (params[:page].to_i - 1) * UnfixedAsset::PAGE_OFFSET
    else
      @offset = 0
    end
    
    @pages = (UnfixedAsset.count / UnfixedAsset::PAGE_OFFSET.to_f).ceil
  end
  
  def set_user
    if params[:user]
      @user = User.where('lower(username) = ?', params[:user].downcase).first
    end
  end
end