=begin rdoc  
  given two lat/lon points, compute the distance between the two points using the haversine formula  
  the result will be a Hash of distances which are key'd by 'mi','km','ft', and 'm'  
=end  

class Haversine
  attr_accessor :distances, :delta
  
  # haversine.rb  
  # http://sawdust.see-do.org/gps/files/HaversineFormulaInRuby.html
  #  
  # haversine formula to compute the great circle distance between two points given their latitude and longitudes  
  #  
  # Copyright (C) 2008, 360VL, Inc  
  # Copyright (C) 2008, Landon Cox  
  #  
  # http://www.360vl.com (360VL, Inc.)  
  # http://sawdust.see-do.org (Landon Cox)  
  #  
  # LICENSE: GNU Affero GPL v3  
  # The ruby implementation of the Haversine formula is free software: you can redistribute it and/or modify  
  # it under the terms of the GNU Affero General Public License version 3 as published by the Free Software Foundation.    
  #  
  # This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the   
  # implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public   
  # License version 3 for more details.  http://www.gnu.org/licenses/  
  #  
  # Landon Cox - 9/25/08  
  #   
  # Notes:  
  #  
  # translated into Ruby based on information contained in:  
  #   http://mathforum.org/library/drmath/view/51879.html  Doctors Rick and Peterson - 4/20/99  
  #   http://www.movable-type.co.uk/scripts/latlong.html  
  #   http://en.wikipedia.org/wiki/Haversine_formula  
  #  
  # This formula can compute accurate distances between two points given latitude and longitude, even for   
  # short distances.  
  # PI = 3.1415926535  
  RAD_PER_DEG = 0.017453293  #  PI/180  
  
  # the great circle distance d will be in whatever units R is in  
  
  Rmiles = 3956           # radius of the great circle in miles  
  Rkm = 6371              # radius in kilometers...some algorithms use 6367  
  Rfeet = Rmiles * 5282   # radius in feet  
  Rmeters = Rkm * 1000    # radius in meters  
  
  def distance( lat1, lon1, lat2, lon2 )  
    dlon = lon2 - lon1  
    dlat = lat2 - lat1  
  
    dlon_rad = dlon * RAD_PER_DEG   
    dlat_rad = dlat * RAD_PER_DEG  
  
    lat1_rad = lat1 * RAD_PER_DEG  
    lon1_rad = lon1 * RAD_PER_DEG  
  
    lat2_rad = lat2 * RAD_PER_DEG  
    lon2_rad = lon2 * RAD_PER_DEG  
  
    # puts "dlon: #{dlon}, dlon_rad: #{dlon_rad}, dlat: #{dlat}, dlat_rad: #{dlat_rad}"  
  
    a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2  
    @delta = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))  
  end  
  
  def to_mi
    Rmiles  * @delta # delta between the two points in miles  
  end

  def to_ft
    Rfeet   * @delta # delta in feet  
  end

  def to_km
    Rkm     * @delta # delta in kilometers  
  end

  def to_m
    Rmeters * @delta # delta in meters  
  end

  def self.delta_to_mi(delta)
    Rmiles * delta
  end

  def self.delta_to_ft(delta)
    Rfeet * delta
  end

  def self.delta_to_km(delta)
    Rkm * delta
  end

  def self.delta_to_m(delta)
    Rmeters * delta
  end
end