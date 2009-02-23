class AddTraveledDistanceToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :traveled_distance, :float
  end

  def self.down
    remove_column :locations, :traveled_distance
  end
end
