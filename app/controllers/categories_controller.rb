class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  
  
  def index
    @categories = Category.all.order(name: :asc)
  end
  
  def new
    @category = Category.new
  end
  
  def create
    @category = Category.create(category_params)
    
    if @category.save
      flash.notice = "Category '#{@category.name}' created successfully"
      redirect_to categories_path
    else
      render 'new'
    end
  end
  
  def show
    redirect_to categories_path if @category.nil?  
  end
  
  def edit; end
  
  def update
    if @category.update(category_params)
      flash.notice = "Category '#{@category.name}' updated successfully"
      redirect_to categories_path
    else
      @category.reload
      render 'edit'
    end
  end
  
  def destroy
    if @category.assets.any?
      flash.alert = "Category '#{@category.name}' not deleted. There is " + 
                    "#{@category.assets.size} assets associated with it. " + 
                    "Remove these associations and try again."
      redirect_to categories_path
    else
      @category.destroy
      flash.notice = " Category '#{@category.name}' deleted successfully"
    end
  end
  
  private
  
  def category_params
    params.require(:category).permit(:name)
  end
  
  def set_category
    @category = Category.where('lower(name) = ?', params[:id].gsub('-', ' '))
                                                                      .first
  end
end