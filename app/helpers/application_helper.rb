module ApplicationHelper
  
  def format_page_title
    @page_title.blank? ? "Employee Asset Manager" : "#{@page_title} - Employee Asset Manager"
  end
end