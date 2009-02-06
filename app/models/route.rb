class Route < ActiveRecord::Base
  
  # Because we entered the route manually, accuracy is very precise
  def horizontal_accuracy
    0
  end
end
