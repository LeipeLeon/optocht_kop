module Admin::AdminHelper
  def admin_menu
    ret = "| " 
    @menu.each {|link, title|
      ret << link_to( title, eval(link+"_path") )
      ret << " | "
    }
    ret
  end
end
