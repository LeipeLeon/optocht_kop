class CreateDeelnemers < ActiveRecord::Migration
  def self.up
    create_table :deelnemers do |t|
      t.string :name
      t.string :site
      t.string :contact_name
      t.string :contact_address
      t.string :contact_postal
      t.string :contact_city
      t.string :contact_telephone
      t.string :contact_email
      t.string :pass
      t.boolean :accepted

      t.timestamps
    end
  end

  def self.down
    drop_table :deelnemers
  end
end
