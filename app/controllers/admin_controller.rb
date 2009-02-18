class AdminController < ApplicationController
  layout proc{ |c| c.request.xhr? ? false : "admin" }
  before_filter :authenticate
  before_filter :menu

  def index
  end

private 
  def menu
    @menu = { "" => "Admin", :locations => "Locations", :feeds => "News Feed", :twitter => "Twitter"}
  end
end