class Location < ActiveRecord::Base
  
  def self.last
    find(:first, :conditions => "horizontal_accuracy < 80", :order => "created_at DESC")#, :limit => 10, :limit => '50'.reverse
  end
end
