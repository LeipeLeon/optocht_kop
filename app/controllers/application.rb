# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'a69690c1e27e81afbd218a9bb77e3341'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  exempt_from_layout('iphone_html.erb')  
    
  before_filter :adjust_format_for_iphone  
    
  protected  
  def iphone_user_agent?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(Mobile\/.+Safari)/]
  end

  def adjust_format_for_iphone    
    request.format = :iphone if iphone_user_agent?
  end
    
  # def check_iphone  
  #   if iphone_user_agent?  
  #     request.parameters[:format] = 'iphone_html'  
  #   end  
  # end  
end  
  
# class DashboardController < ApplicationController  
#   def index  
#     @top_movies = Movie.top_movies  
#     @movie = @top_movies.first  
#       
#     respond_to do |format|  
#       format.html # index.html.erb  
#       format.iphone_html #index.iphone_html.erb  
#     end  
#   end  
# end  