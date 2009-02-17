class HomeController < ApplicationController
  before_filter :get_feed
  def index
    @page_title = t('home.home')
    render
  end
  
  def about
    @page_title = t('home.about')
    render
  end

private
  def get_feed
    @feed = Feed.last(3)
  end
end