class Admin::AdminController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "admin" }
  before_filter :authenticate
  before_filter :menu

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
    end
  end

private 
  def menu
    @menu = { 
      "admin" => "Admin", 
      "admin_locations" => "Locations", 
      "admin_feeds" => "News Feed", 
      "admin_twitter_index" => "Twitter"
    }
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == AUTH_KEYS['username'] && password == AUTH_KEYS['password']
    end
  end
end
