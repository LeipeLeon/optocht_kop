class HomeController < ApplicationController
  before_filter :get_feed
  def index
    @page_title = t('home.home')
    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
    end
  end
  
  def about
    @page_title = t('home.about')
    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
    end
  end

private
  def get_feed
    @feed = Feed.last(3)
  end
end