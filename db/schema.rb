# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090205182041) do

  create_table "comatose_page_versions", :force => true do |t|
    t.integer  "comatose_page_id"
    t.integer  "version"
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type",      :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                       :default => 0
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "comatose_pages", :force => true do |t|
    t.integer  "parent_id"
    t.text     "full_path"
    t.string   "title"
    t.string   "slug"
    t.string   "keywords"
    t.text     "body"
    t.string   "filter_type", :limit => 25, :default => "Textile"
    t.string   "author"
    t.integer  "position",                  :default => 0
    t.integer  "version"
    t.datetime "updated_on"
    t.datetime "created_on"
  end

  create_table "deelnemers", :force => true do |t|
    t.string   "name"
    t.string   "site"
    t.string   "contact_name"
    t.string   "contact_address"
    t.string   "contact_postal"
    t.string   "contact_city"
    t.string   "contact_telephone"
    t.string   "contact_email"
    t.string   "pass"
    t.boolean  "accepted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.float    "altitude"
    t.float    "horizontal_accuracy"
    t.float    "vertical_accuracy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "altitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
