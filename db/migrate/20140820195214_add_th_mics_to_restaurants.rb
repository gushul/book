class AddThMicsToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :th_misc, :text
  end

  def self.down
    remove_column :restaurants, :th_misc
  end
end
