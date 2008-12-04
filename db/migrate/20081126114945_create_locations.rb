class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.float :latitude,  :limit => 7
      t.float :longitude, :limit => 7
      t.float :altitude
      t.float :horizontal_accuracy
      t.float :vertical_accuracy
      t.timestamps
    end
    
    execute "ALTER TABLE `locations` CHANGE `latitude` `latitude` real DEFAULT NULL ;"
    execute "ALTER TABLE `locations` CHANGE `longitude` `longitude` real DEFAULT NULL ;"

  end

  def self.down
    drop_table :locations
  end
end
