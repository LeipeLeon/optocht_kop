class LocationsController < ApplicationController
  before_filter :authenticate, :except => [:index, :create, :last_locations, :just_map, :create_thumb]

  # layout "iphone"
  def index
    @page.title = t('location.title')
    @locations = Location.find(:all, :conditions => "horizontal_accuracy < 80", :order => "created_at DESC", :limit => 10 )#, :limit => '50'.reverse

    if @locations
      get_map
      set_zoom
      get_head
    else
      flash[:notice] = 'Er is nog geen data geladen!'
    end

    respond_to do |format|
      format.iphone
      format.html do
        get_route if @locations
      end
      format.js do
        get_route if @locations
      end
    end
  end

  def last_locations
    @map = Variable.new("map")
    # @map = GMap.new("map")

    # params[:last_update]
    @locations = Location.find(:all, :conditions => "horizontal_accuracy < 80", :order => "created_at DESC", :limit => 10 )#, :limit => '50'.reverse
    head  = get_head('add')
    route = get_route('add')
    center = set_zoom('add')

    respond_to do |format|
      format.js do# index.html.erb  
        render :update do |page|
          page << @map.clear_overlays
          page << head
          page << route
          page << center
        end
        # get_accuracy
      end
    end
  end

  def just_map
    @page.title = t('location.title')
    @locations = Location.find(:all, :conditions => "horizontal_accuracy < 80", :order => "created_at DESC", :limit => 10 )#, :limit => '50'.reverse

    get_map(false,false)
    set_zoom('init', 16)
    get_head
    get_route

  end

  def new
    @page.title = t('location.new')
    @location = Location.new
  end
  
  def create
    logger.debug request.env["HTTP_USER_AGENT"]
    # if request.env["HTTP_USER_AGENT"] == "beriedataphone"
      @location = Location.new(params[:location])

      if @location.save
        # flash[:notice] = "Location successfully created. #{Time.now}"
        render :text => "Loc. Created @ #{Time.now}"
      else
        flash[:notice] = 'Error on creation.'
      end
    # else
    #   render :text => "Wrong device!"
    # end
  end

  def create_thumb
    url = 'http://webserver.vda-groep.nl/locations/just_map.html'
    t = Nailer.new(url, 320, 300)

    if t.ok?
      t.wait_until_ready
      # t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/out1.jpg", :small)
      # t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/out2.jpg", :medium)
      t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/out3.jpg", :medium2)
      # t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/out4.jpg", :large)
      render :text => "Thumbnails saved /thumb/out1.jpg"
    else
      render :text => "Error"
    end    
  end

private
  def get_accuracy_icon(accuracy)
    @accuracy_icons[((accuracy / 10)*10)]
  end

  def get_accuracy
    @accuracy = "<p>Precisie: +/- <%= @locations.first.horizontal_accuracy.to_i %> meter, <%= distance_of_time_in_dutch(@locations.first.created_at, Time.now, true) %> geleden</p>"
  end

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == "foo" && password == "bar"
    end
  end
  
  def get_map(large_map = true, map_type = true)
    # Create a new map object, also defining the div ("map") 
    # where the map will be rendered in the view
    @map = GMap.new("map")
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => large_map, :map_type => map_type)    
  end
  
  def get_head(type= 'init')
    # create the icon : "/images/knob_big.png"
    last_location = Variable.new("last_location")
    if @locations.first.horizontal_accuracy.to_i < 100
      @map.icon_global_init(GIcon.new(:image => "/images/knob_small.png",
         :icon_anchor => GPoint.new(78/2,78/2),
         :info_window_anchor => GPoint.new(78/2,78/2)), "last_location")
    else
      @map.icon_global_init(GIcon.new(:image => "/images/knob_big.png",
         :icon_anchor => GPoint.new(191/2,191/2),
         :info_window_anchor => GPoint.new(191/2,191/2)), "last_location")
    end

    kop_optocht_info = "Kop Optocht"
    kop_optocht = GMarker.new([@locations.first.latitude, @locations.first.longitude], 
          :icon => last_location )

    case type 
    when 'init': @map.overlay_init(kop_optocht)
    when 'add':  @map.add_overlay(kop_optocht)
    else         @map.overlay_init(kop_optocht)
    end
  end

  def set_zoom(type = 'init', level = 17) # Center the map on specific coordinates and focus in fairly closely
    case type 
    when 'add':  @map.set_center(GLatLng.new([@locations.first.latitude, @locations.first.longitude]))
    else         @map.center_zoom_init([@locations.first.latitude, @locations.first.longitude], level)
    end
  end
  
  def get_route(type = 'init')
    # Maak alle icons voor accuracy
    @accuracy_icons = {
      0 => @map.icon_global_init(GIcon.new(:image => "/images/accuracy_icon_0.png",
         :icon_anchor => GPoint.new(15,15),
         :info_window_anchor => GPoint.new(15,15)), "img_route_point_0",
         :icon_size => GSize.new(30,30))      
    }
    10.step(100,10) { |point|
      @map.icon_global_init(GIcon.new(:image => "/images/acc_icon_#{point}.png",
         :icon_anchor => GPoint.new(point/2,point/2),
         :info_window_anchor => GPoint.new(point/2,point/2)), "img_route_point_#{point}",
         :iconSize => GSize.new(point,point))
      @accuracy_icons[point] = Variable.new("img_route_point_#{point}")
    }

    @route_points = []
    markers1 = []

    # alle meetpunten definieren
    @locations.each { |loc|
      @route_points << [loc.latitude, loc.longitude]
      markers1 << GMarker.new([loc.latitude, loc.longitude], 
          :icon => get_accuracy_icon(loc.horizontal_accuracy.to_i))
    }
    # laat registratiepunten allee nzien op level 16-17
    managed_markers1 = ManagedMarker.new(markers1,16,17)

    route = GPolyline.new(@route_points,"#ff0000",5,1.0)
    route_2 = GPolyline.new(@route_points,"#ffcc00",3,0.8)
      
    mm = GMarkerManager.new(@map,:managed_markers => [managed_markers1])
    ret = Array.new()
    case type 
    when 'add':  
      # ret << @map.declare(mm, "mgr")
      ret << @map.add_overlay(route)
      ret << @map.add_overlay(route_2)
    else         
      # ret << @map.declare_init(mm, "mgr")
      ret << @map.overlay_init(route)
      ret << @map.overlay_init(route_2)
    end
    ret
  end
end

