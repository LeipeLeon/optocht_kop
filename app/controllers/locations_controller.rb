class LocationsController < ApplicationController
  before_filter :authenticate, :except => [:index, :create, :last_locations, :just_map, :static]
  before_filter :get_db_points, :only => [:index, :last_locations, :static]

  # layout "iphone"
  def index
    # we're not started yet, so move over to the start.
    unless @location
      @location = @route.first
      flash.now[:notice] = t(:'no_data_available')
    end
    get_map
    set_zoom
    get_head
    get_route if @location
    # get_traveled if @location.size > 0

    respond_to do |format|
      format.mobile
      format.html
      format.js
    end
  end

  def last_locations
    @map = Variable.new("map")
    
    unless @location
      @location = @route.first
      flash.now[:notice] = t(:'no_data_available')
    end

    head  = get_head('add')
    # traveled = get_traveled('add')
    route = get_route('add')
    center = set_zoom('add')

    render :update do |page|
      page << @map.clear_overlays
      page << head
      page << route
      # page << traveled
      page << center
    end
  end

  def new
    @page_title = t('location.new')
    @location = Location.new
  end

  def static
    @map_types = {
      :terrain => "Terrein",
      :mobile => "Hoog contrast",
      :roadmap => "Standaard",
      :satellite => "Satteliet",
      :hybrid => "Hybride"
    }

    route_points = ""
    @route.each { |loc|
      route_points << "|#{loc.latitude},#{loc.longitude}"
    }

    @static_url = "http://maps.google.com/staticmap"
    @static_url << "?center=#{@center.latitude},#{@center.longitude}"
    if @location
      @static_url << "&markers=#{@location.latitude},#{@location.longitude},bluek"
    else
      @static_url << "&markers=#{@route.first.latitude},#{@route.first.longitude},bluek"
      flash.now[:notice] = t(:'no_data_available')
    end
    @static_url << "&zoom=13"
    @static_url << "&maptype=#{params[:type] || "terrain"}"
    @static_url << "&sensor=false"
    @static_url << "&key=" + ApiKey.get(:host => request.host)
    @static_url << "&path=rgba:0xff0000ff,weight:5" + route_points
    @static_url << "&path=rgba:0xffcc00ff,weight:3" + route_points
    
    respond_to do |format|
      format.html   { @static_url << "&size=640x480" }
      format.mobile { @static_url << "&size=270x270" }
    end
  end
  
  def create
    logger.debug request.env["HTTP_USER_AGENT"]
    # if request.env["HTTP_USER_AGENT"] == "beriedataphone"
      @location = Location.new(params[:location])

      if @location.save
        # flash[:notice] = "Location successfully created. #{Time.now}"
        respond_to do |format|
          format.mobile  { 
            # head :ok 
            render :text => "Loc. Created @ #{Time.now}"
          }
          format.html { redirect_to(:controller => :home) }
        end
      else
        flash[:notice] = 'Error on creation.'
        respond_to do |format|
          format.mobile  { 
            # head :ok 
            render :text => "Error on creation of location"
          }
          format.html { render :action => "edit" }
        end
      end
    # else
    #   render :text => "Wrong device!"
    # end
  end

private
  def get_db_points
    @page_title = t('location.title')
    @location = Location.last
    @route    = Route.find(:all)
    if request.format == :mobile
      @center = @location || @route.first
    else
      @center = Route.center
    end
  end

  def get_accuracy_icon(accuracy)
    @accuracy_icons[((accuracy / 10)*10)]
  end

  def get_accuracy
    @accuracy = "<p>Precisie: +/- <%= @location.horizontal_accuracy.to_i %> meter, <%= distance_of_time_in_dutch(@location.created_at, Time.now, true) %> geleden</p>"
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
    if @location.horizontal_accuracy.to_i < 100
      @map.icon_global_init(GIcon.new(:image => "#{ActionController::Base.relative_url_root}/images/knob_small.png",
         :icon_anchor => GPoint.new(78/2,78/2),
         :info_window_anchor => GPoint.new(78/2,78/2)), "last_location")
    else
      @map.icon_global_init(GIcon.new(:image => "#{ActionController::Base.relative_url_root}/images/knob_big.png",
         :icon_anchor => GPoint.new(191/2,191/2),
         :info_window_anchor => GPoint.new(191/2,191/2)), "last_location")
    end

    kop_optocht_info = "Kop Optocht"
    kop_optocht = GMarker.new([@location.latitude, @location.longitude], 
          :icon => last_location )

    case type 
    when 'init': @map.overlay_init(kop_optocht)
    when 'add':  @map.add_overlay(kop_optocht)
    else         @map.overlay_init(kop_optocht)
    end
  end

  def set_zoom(type = 'init', level = 13) # Center the map on specific coordinates and focus in fairly closely
    case type 
    when 'add':  @map.set_center(GLatLng.new([@center.latitude, @center.longitude]))
    else         @map.center_zoom_init([@center.latitude, @center.longitude], level)
    end
  end
  
  def get_traveled(type = 'init')
    @traveled_points = []
    markers1 = []

    create_accuracy_icons

    # alle meetpunten definieren
    @location.each { |loc|
      @traveled_points << [loc.latitude, loc.longitude]
      markers1 << GMarker.new([loc.latitude, loc.longitude], 
          :icon => get_accuracy_icon(loc.horizontal_accuracy.to_i))
    }
    # laat registratiepunten allee nzien op level 16-17
    managed_markers1 = ManagedMarker.new(markers1,16,17)

    traveled = GPolyline.new(@traveled_points,"#ff0000",5,1.0)
    traveled_2 = GPolyline.new(@traveled_points,"#ffcc00",3,0.8)
      
    mm = GMarkerManager.new(@map,:managed_markers => [managed_markers1])

    if type == 'init' 
      [@map.overlay_init(traveled), @map.overlay_init(traveled_2)]
    else         
      [@map.add_overlay(traveled), @map.add_overlay(traveled_2)]
    end
  end

  def get_markers(type = 'init')
    markers1 = []
    create_accuracy_icons
    @route.each { |loc|
      markers1 << GMarker.new([loc.latitude, loc.longitude], 
          :icon => get_accuracy_icon(10))
    }
    # laat registratiepunten alleen zien op level 16-17
    managed_markers1 = ManagedMarker.new(markers1,16,17)
    mm = GMarkerManager.new(@map,:managed_markers => [managed_markers1])

    if type == 'init' 
      @map.declare_init(mm, "mgr")
    else         
      @map.declare(mm, "mgr")
    end
  end

  def get_route(type = 'init')
    @route_points = []

    create_accuracy_icons

    # alle meetpunten definieren
    @route.each { |loc|
      @route_points << [loc.latitude, loc.longitude]
    }

    route = GPolyline.new(@route_points,"#ff0000",5,1.0)
    route_2 = GPolyline.new(@route_points,"#ffcc00",3,0.8)
      
    if type == 'init' 
      [@map.overlay_init(route), @map.overlay_init(route_2)]
    else
      [@map.add_overlay(route), @map.add_overlay(route_2)]
    end
  end

  # Maak alle icons voor accuracy
  def create_accuracy_icons
    return @accuracy_icons if @accuracy_icons
    @accuracy_icons = {
      0 => @map.icon_global_init(GIcon.new(:image => "#{ActionController::Base.relative_url_root}/images/accuracy_icon_0.png",
         :icon_anchor => GPoint.new(15,15),
         :info_window_anchor => GPoint.new(15,15)), "img_route_point_0",
         :icon_size => GSize.new(30,30))
    }
    10.step(100,10) { |point|
      @map.icon_global_init(GIcon.new(:image => "#{ActionController::Base.relative_url_root}/images/acc_icon_#{point}.png",
         :icon_anchor => GPoint.new(point/2,point/2),
         :info_window_anchor => GPoint.new(point/2,point/2)), "img_route_point_#{point}",
         :iconSize => GSize.new(point,point))
      @accuracy_icons[point] = Variable.new("img_route_point_#{point}")
    }
  end
end

