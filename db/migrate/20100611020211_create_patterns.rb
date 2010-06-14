class CreatePatterns < ActiveRecord::Migration
  def self.up
    create_table :patterns do |t|
      t.string  :pid,         :limit => 10
      t.float   :length
      t.string  :direction

      t.timestamps
    end

    add_index :patterns, :pid, :unique => true
  end

  def self.down
    drop_table :patterns
  end
end
