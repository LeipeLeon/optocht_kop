class LocationsController < ApplicationController
  layout "iphone"
  def index
    @locations = Location.find(:all, :conditions => "horizontal_accuracy < 80", :order => "created_at DESC")#, :limit => '50'.reverse
    # 
    # Create a new map object, also defining the div ("map") 
    # where the map will be rendered in the view
    @map = GMap.new("map")
    # Use the larger pan/zoom control but disable the map type
    # selector
    @map.control_init(:large_map => true, :map_type => true)
    # Center the map on specific coordinates and focus in fairly
    # closely
    @map.center_zoom_init([@locations.first.latitude, @locations.first.longitude], 17)
    # create the pzza icon : "/images/knob_big.png"
    if @locations.first.horizontal_accuracy.to_i < 100
      @map.icon_global_init(GIcon.new(:image => "/images/knob_small.png",
         :icon_anchor => GPoint.new(78/2,78/2),
         :info_window_anchor => GPoint.new(78/2,78/2)), "last_location")
    else
      @map.icon_global_init(GIcon.new(:image => "/images/knob_big.png",
         :icon_anchor => GPoint.new(191/2,191/2),
         :info_window_anchor => GPoint.new(191/2,191/2)), "last_location")
    end
    @map.icon_global_init(GIcon.new(:image => "/images/slider_ball.png",
       :icon_anchor => GPoint.new(25/2,25/2),
       :info_window_anchor => GPoint.new(25/2,25/2)), "img_route_point")

    last_location = Variable.new("last_location")
    img_route_point = Variable.new("img_route_point")

    @route_points = []
    markers1 = []

    @locations.each { |loc|
      @route_points << [loc.latitude, loc.longitude]
      markers1 << GMarker.new([loc.latitude, loc.longitude], 
          :icon => loc.horizontal_accuracy.to_i > 50 ? last_location : img_route_point )#,
    }
    # laat registratiepunten allee nzien op level 16-17
    managed_markers1 = ManagedMarker.new(markers1,14,17)

    kop_optocht_info = "Kop Optocht"
    kop_optocht = GMarker.new([@locations.first.latitude, @locations.first.longitude], 
          :icon => last_location )#,
          # :title => 'Deventer', 
          # :info_window => "#{kop_optocht_info}")

    route = GPolyline.new(@route_points,"#ff0000",5,1.0)
    route_2 = GPolyline.new(@route_points,"#ffcc00",3,0.8)
          
    mm = GMarkerManager.new(@map,:managed_markers => [managed_markers1])
    @map.declare_init(mm, "mgr")
    @map.overlay_init(route)
    @map.overlay_init(route_2)
    @map.overlay_init(kop_optocht)
  end
  
  def new
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

end

  