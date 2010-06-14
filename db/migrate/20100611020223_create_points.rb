class CreatePoints < ActiveRecord::Migration
  def self.up
    create_table :points do |t|
      t.integer :pid,         :limit => 10
      t.integer :sequence
      t.float   :lat,         :precision => 3, :scale => 15
      t.float   :lon,         :precision => 3, :scale => 15
      t.string  :pttype,      :limit => 1
      t.string  :stid,        :limit => 10
      t.string  :stname
      t.float   :distance

      t.timestamps
    end

    add_index :points, [:pid, :sequence], :unique => true
  end

  def self.down
    drop_table :points
  end
end
