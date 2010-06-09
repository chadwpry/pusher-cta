class CreateVehicles < ActiveRecord::Migration
  def self.up
    create_table :vehicles do |t|
      t.string  :vid
      t.string  :vrid

      t.timestamps
    end

    add_index :vehicles, :vid, :unique => true
    add_index :vehicles, :vrid
  end

  def self.down
    drop_table :vehicles
  end
end
