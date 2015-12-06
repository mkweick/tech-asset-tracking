class FixedAssetsController < ApplicationController
  before_action :require_admin
  before_action :set_fa, only: [:edit, :update, :destroy]
  before_action :set_fa_user, only: [:destroy]
  before_action :set_filter_sort, only: [:index]
  before_action :set_pages_offset, only: [:index]
  
  def index
    @fas = FixedAsset.select("ctg.name AS ctg_name, mfg_name, model_num, serial_num, 
                              purchase_date, users.username AS username,
                              users.last_name || ', ' || users.first_name AS assigned")
                     .joins("LEFT JOIN categories AS ctg 
                                ON fixed_assets.category_id = ctg.id")
                     .joins("LEFT JOIN fixed_assignments AS fa_asn 
                                ON fixed_assets.id = fa_asn.fixed_asset_id")
                     .joins("LEFT JOIN users ON fa_asn.user_id = users.id")
                     .order("#{@filter} #{@sort}")
                     .offset(@offset)
                     .limit(FixedAsset::PAGE_OFFSET)
  end
  
  def new
    @fa = FixedAsset.new
  end
  
  def create
    @fa = FixedAsset.create(fa_params)
    
    if @fa.save
      flash.notice = "Fixed Asset successfully created"
      redirect_to fixed_assets_path
    else
      render 'new'
    end
  end
  
  def edit; end
  
  def update
    if @fa.update(fa_params)
      flash.notice = "Fixed Asset successfully updated"
      redirect_to fixed_assets_path
    else
      @fa.reload
      render 'edit'
    end
  end
  
  def destroy
    if @fa.destroy
      flash.notice = "Fixed Asset (serial# #{ @fa.serial_num }) 
                      successfully deleted"
    else
      flash.alert = "Fixed Asset (serial# #{ @fa.serial_num }) can't 
                     be deleted. Asset still asigned to 
                     #{ view_context.link_to @user.first_name + " " + 
                                             @user.last_name, user_path(@user),
                                             class: "ks-red-light" }"
    end
    redirect_to fixed_assets_path
  end
  
  private
  
  def fa_params
    params.require(:fixed_asset).permit(:category_id, :mfg_name, :model_num,
                                      :serial_num, :description, :purchase_date)
  end
  
  def set_fa
    @fa = FixedAsset.where('lower(serial_num) = ?', params[:id].downcase)
                                                                    .first
  end
  
  def set_fa_user
    @user = @fa.user
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
      @offset = (params[:page].to_i - 1) * FixedAsset::PAGE_OFFSET
    else
      @offset = 0
    end
    
    @pages = (FixedAsset.count / FixedAsset::PAGE_OFFSET.to_f).ceil
  end
end