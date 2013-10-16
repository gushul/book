class ChangeLargestTableToIntegerFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :largest_table
    add_column    :restaurants, :largest_table, :integer
  end
end
