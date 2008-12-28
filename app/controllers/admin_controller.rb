class AdminController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "admin" }
  before_filter :authenticate

  def index
    render :text => "Admin Section"
  end

private
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "foo" && password == "bar"
    end
  end
  

end