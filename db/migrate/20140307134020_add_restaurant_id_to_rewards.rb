class AddRestaurantIdToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :restaurant_id, :integer
  end
end
