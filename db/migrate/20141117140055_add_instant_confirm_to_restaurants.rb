class AddInstantConfirmToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :instant_confirm, :boolean, :default => true
  end
end
