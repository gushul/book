class RidCategoryCuisinePriceFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :price
    remove_column :restaurants, :cuisine
    remove_column :restaurants, :category
  end
end
