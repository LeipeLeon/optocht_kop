class Admin::TwitterController < AdminController
  before_filter :authenticate

  def index
    @tweets = Twitter.read_status(:count => 5)

    respond_to do |format|
      format.html # index.html.erb
      format.iphone # index.iphone.erb
      format.xml  { render :xml => @twitter }
    end
  end

  # GET /twitter/new
  # GET /twitter/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.iphone # new.html.erb
      format.xml  { render :xml => @Twitter }
    end
  end


  # POST /twitter
  # POST /twitter.xml
  def create
    @tweet = Twitter.update(params[:tweet][:text])

    respond_to do |format|
      if @tweet
        flash[:notice] = 'Tweet was successfully created.'
        format.html { redirect_to(:action => :index) }
        format.xml  { render :xml => @tweet, :status => :created, :tweet => @tweet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tweet.errors, :status => :unprocessable_entity }
      end
    end
  end
end