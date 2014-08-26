class AddRcodeToUser < ActiveRecord::Migration
  
  def self.up
    add_column :users, :r_code, :string
  end

  def self.down
    remove_column :users, :r_code
  end
end
