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

ActiveRecord::Schema.define(:version => 20100605222356) do

  create_table "locations", :force => true do |t|
    t.string   "vid",         :limit => 10
    t.string   "vrid",        :limit => 10
    t.string   "pid",         :limit => 10
    t.integer  "pdistance"
    t.string   "timestamp"
    t.string   "heading"
    t.string   "destination"
    t.boolean  "delayed"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["vid", "lat", "lon"], :name => "index_locations_on_vid_and_lat_and_lon"

  create_table "stops", :force => true do |t|
    t.string   "stid"
    t.string   "vrid"
    t.string   "direction"
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stops", ["stid"], :name => "index_stops_on_stid", :unique => true

  create_table "vehicle_routes", :force => true do |t|
    t.string   "vrid",       :limit => 10
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicle_routes", ["vrid"], :name => "index_vehicle_routes_on_vrid", :unique => true

  create_table "vehicles", :force => true do |t|
    t.string   "vid"
    t.string   "vrid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicles", ["vid"], :name => "index_vehicles_on_vid", :unique => true
  add_index "vehicles", ["vrid"], :name => "index_vehicles_on_vrid"

end
