class AddVridToPattern < ActiveRecord::Migration
  def self.up
    add_column :patterns, :vrid, :string, :limit => 10

    Pattern.delete_all
  end

  def self.down
    remove_column :patterns, :vrid
  end
end
