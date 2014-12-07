class AddAppleDeviceItToOwner < ActiveRecord::Migration
  def change
    add_column :owners, :apple_device_id, :string
  end
end
