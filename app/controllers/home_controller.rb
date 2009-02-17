class HomeController < ApplicationController

  def index
    @page_title = t('home.home')
    render
  end
  
  def about
    @page_title = t('home.about')
    render
  end
end