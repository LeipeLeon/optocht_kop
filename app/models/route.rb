class Route < ActiveRecord::Base
  
  # Because we entered the route manually, accuracy is very precise
  def horizontal_accuracy
    0
  end
  
  def self.center
    row = find_by_sql("SELECT 
      MIN(latitude)+(MAX(latitude)-MIN(latitude))/2 latitude, 
      MIN(longitude)+(MAX(longitude)-MIN(longitude))/2 longitude 
      FROM routes LIMIT 1").first
  end
end
