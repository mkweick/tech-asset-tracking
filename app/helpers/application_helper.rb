module ApplicationHelper
  
  def format_page_title
    @page_title.blank? ? "Keller Safety" : "#{@page_title} - Keller Safety"
  end
end