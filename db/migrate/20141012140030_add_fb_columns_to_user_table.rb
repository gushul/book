class AddFbColumnsToUserTable < ActiveRecord::Migration
  def self.up
    add_column :users, :android_device_id, :string
    add_column :users, :fb_uid, :string, :null => true
    add_column :users, :fb_access_token, :string, :null => true
  end

  def self.down
    remove_column :users, :android_device_id
    remove_column :users, :fb_uid
    remove_column :users, :fb_access_token
  end
end
