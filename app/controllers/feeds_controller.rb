class FeedsController < ApplicationController
  # GET /feeds
  # GET /feeds.xml
  before_filter :set_page_title, :except => [:create, :destroy]

  def index
    @feeds = Feed.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
      format.xml  { render :xml => @feeds }
    end
  end

  # GET /feeds/1
  # GET /feeds/1.xml
  def show
    @feed = Feed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.mobile # show.mobile.erb
      format.xml  { render :xml => @feed }
    end
  end

private
  def set_page_title
    @page_title = t('feed.title')
  end

end
