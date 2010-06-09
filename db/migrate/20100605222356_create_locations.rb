class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string  :vid,         :limit => 10
      t.string  :vrid,        :limit => 10
      t.string  :pid,         :limit => 10
      t.integer :pdistance
      t.string  :timestamp
      t.string  :heading
      t.string  :destination
      t.boolean :delayed
      t.float   :lat,         :precision => 3, :scale => 15
      t.float   :lon,         :precision => 3, :scale => 15

      t.timestamps
    end

    add_index :locations, [:vid, :lat, :lon]
  end

  def self.down
    drop_table :locations
  end
end
