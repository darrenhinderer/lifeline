module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def import_javascript(*imports)
    javascript_links = ""
    content_for(:import_javascript) do 
      imports.each do |import|
        javascript_links += javascript_include_tag(import) 
      end
      javascript_links
    end
  end

end
