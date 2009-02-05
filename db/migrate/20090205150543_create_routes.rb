class CreateRoutes < ActiveRecord::Migration
  def self.up
    create_table :routes do |t|
      t.float :latitude
      t.float :longitude
      t.integer :altitude

      t.timestamps
    end
  end

  def self.down
    drop_table :routes
  end
end
