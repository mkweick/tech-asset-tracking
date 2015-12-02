module CategoriesHelper
  
  def ctg_btn(category)
    category.new_record? ? "Create Category" : "Update Category"
  end
end