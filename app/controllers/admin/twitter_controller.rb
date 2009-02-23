class Admin::TwitterController < Admin::AdminController
  before_filter :authenticate

  def index
    @tweets = FuKing::Twitter.read_status(:count => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
      format.xml  { render :xml => @twitter }
    end
  end

  # POST /twitter
  # POST /twitter.xml
  def create
    @tweet = FuKing::Twitter.update(params[:tweet][:text])

    respond_to do |format|
      if @tweet
        flash[:notice] = 'Tweet was successfully created.'
        format.html { redirect_to(:action => :index) }
        format.mobile { redirect_to(:action => :index) }
        format.xml  { render :xml => @tweet, :status => :created, :tweet => @tweet }
      else
        format.html { render :action => "new" }
        format.mobile { render :action => "new" }
        format.xml  { render :xml => @tweet.errors, :status => :unprocessable_entity }
      end
    end
  end
end