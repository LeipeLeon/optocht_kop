require 'rubygems'
require 'nailer'

desc "Calculate the distance between updates" 
task :calculate_dist => :environment do 
  prev_loc = nil
  locations = Location.find(:all, :order => "created_at ASC")
  
  locations.each { |loc|
    unless prev_loc.blank?
      dist = Haversine.new
      dist.distance(
        prev_loc.latitude, 
        prev_loc.longitude, 
        loc.latitude, 
        loc.longitude
      )
      loc.update_attribute(:traveled_distance, dist.delta)
    end
    prev_loc = loc
  }
end
