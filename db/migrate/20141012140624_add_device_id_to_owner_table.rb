class AddDeviceIdToOwnerTable < ActiveRecord::Migration
  def self.up
    add_column :owners, :device_id, :string
  end

  def self.down
    remove_column :owners, :device_id
  end
end
