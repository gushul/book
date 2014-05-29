class AddActiveToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :active, :boolean, :null => false, :default => true
  end
end
