class AddMetaToRestaurantTable < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :meta_kw, :string
    add_column :restaurants, :meta_desc, :string
  end

  def self.down
    remove_column :restaurants, :meta_desc
    remove_column :restaurants, :meta_desc
  end
end
