class Admin::LocationsController < Admin::AdminController
  before_filter :set_page_title, :except => [:create, :destroy]
  # GET /admin/locations
  # GET /admin/locations.xml

  def index
    @locations = Location.paginate :page => params[:page], :order => "created_at DESC", :limit => 25

    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
      format.xml  { render :xml => @locations }
    end
  end

  # GET /admin/locations/1
  # GET /admin/locations/1.xml
  def show
    @locations = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.mobile # index.mobile.erb
      format.xml  { render :xml => @locations }
    end
  end

  # GET /admin/locations/new
  # GET /admin/locations/new.xml
  def new
    @locations = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.mobile # index.mobile.erb
      format.xml  { render :xml => @locations }
    end
  end

  # GET /admin/locations/1/edit
  def edit
    @locations = Location.find(params[:id])
  end

  # POST /admin/locations
  # POST /admin/locations.xml
  def create
    @locations = Location.new(params[:location])

    respond_to do |format|
      if @locations.save
        flash[:notice] = 'Locations was successfully created.'
        format.html { redirect_to(admin_locations_url) }
        format.mobile { redirect_to(admin_locations_url) }
        format.xml  { render :xml => @locations, :status => :created, :location => @locations }
      else
        format.html { render :action => "new" }
        format.mobile { render :action => "new" }
        format.xml  { render :xml => @locations.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/locations/1
  # PUT /admin/locations/1.xml
  def update
    @locations = Location.find(params[:id])

    respond_to do |format|
      if @locations.update_attributes(params[:location])
        flash[:notice] = 'Locations was successfully updated.'
        format.html { redirect_to(admin_locations_url) }
        format.mobile { redirect_to(admin_locations_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.mobile { render :action => "edit" }
        format.xml  { render :xml => @locations.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/locations/1
  # DELETE /admin/locations/1.xml
  def destroy
    @locations = Location.find(params[:id])
    @locations.destroy

    respond_to do |format|
      format.html { redirect_to(admin_locations_url) }
      format.mobile { redirect_to(admin_locations_url) }
      format.xml  { head :ok }
    end
  end

private
  def set_page_title
    @page_title = t('location.title')
  end

end
