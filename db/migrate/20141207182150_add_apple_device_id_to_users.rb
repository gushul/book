class AddAppleDeviceIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apple_device_id, :string
  end
end
