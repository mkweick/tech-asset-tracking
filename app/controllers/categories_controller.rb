class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:index, :destroy]
  before_action :require_user, only: [:index, :show]
  before_action :set_user, only: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  
  
  def index; end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.create(category_params)
    
    if @category.save
      flash.notice = "#{@category.name} category created successfully"
      redirect_to categories_path
    else
      render 'new'
    end
  end
  
  def show
    redirect_to categories_path if @category.nil?
    
    if @user
      @open_fas = @category.fixed_assets
                           .where('id NOT IN (SELECT fixed_asset_id 
                                   FROM fixed_assignments)')
    else
      @open_ufas = @category.unfixed_assets
                            .where('id NOT IN (SELECT unfixed_asset_id 
                                    FROM unfixed_assignments)')
    end
  end
  
  def edit; end
  
  def update
    if @category.update(category_params)
      flash.notice = "#{@category.name} category updated successfully"
      redirect_to categories_path
    else
      @category.reload
      render 'edit'
    end
  end
  
  def destroy
    if @category.destroy
      flash.notice = "#{@category.name} category deleted successfully"
    else
      flash.alert = "#{@category.name} can't be deleted. Fixed or Unfixed 
                     assets still exist."
    end
    redirect_to categories_path
  end
  
  private
  
  def category_params
    params.require(:category).permit(:name)
  end
  
  def set_category
    @category = Category.where('lower(name) = ?', params[:id].gsub('-', ' '))
                                                             .first
  end
  
  def set_categories
    @categories = Category.order(name: :asc)
  end
  
  def set_user
    if params[:user]
      if admin?
        @user = User.where('lower(username) = ?', params[:user].downcase).first
      else
        access_denied
      end
    end
  end
end