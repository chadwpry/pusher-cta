class CreateStops < ActiveRecord::Migration
  def self.up
    create_table :stops do |t|
      t.string  :stid
      t.string  :vrid,   :maximum => 10
      t.string  :direction
      t.string  :name
      t.float   :lat,   :precision => 3, :scale => 15
      t.float   :lon,   :precision => 3, :scale => 15

      t.timestamps
    end

    add_index :stops, :stid, :unique => true
  end

  def self.down
    drop_table :stops
  end
end
