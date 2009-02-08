# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  helper :all # include all helpers, all the time
  has_mobile_fu

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'a69690c1e27e81afbd218a9bb77e3341'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
    
  before_filter :adjust_format_for_mobile
  before_filter :set_page_vars, :except => [:create, :destroy]

protected  
  def adjust_format_for_mobile    
    request.format = :iphone if in_mobile_view?
  end
    
  # def set_page_vars
  #   @page = ComatosePage.new
  # end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == AUTH_KEYS['username'] && password == AUTH_KEYS['password']
    end
  end
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