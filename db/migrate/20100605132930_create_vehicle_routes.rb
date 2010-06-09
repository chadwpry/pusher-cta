class CreateVehicleRoutes < ActiveRecord::Migration
  def self.up
    create_table :vehicle_routes do |t|
      t.string  :vrid,  :limit => 10
      t.string  :name

      t.timestamps
    end

    add_index :vehicle_routes, :vrid, :unique => true
  end

  def self.down
    drop_table :vehicle_routes
  end
end
