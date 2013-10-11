class AddLargestTableToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :largest_table, :text
  end
end
