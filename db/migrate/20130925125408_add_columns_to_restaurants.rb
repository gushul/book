class AddColumnsToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :days_in_advance,  :integer
    add_column :restaurants, :min_booking_time, :integer
    add_column :restaurants, :res_duration,     :integer
  end
end
