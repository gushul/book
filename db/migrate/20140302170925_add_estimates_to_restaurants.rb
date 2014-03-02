class AddEstimatesToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :est_duration,            :integer
    add_column :restaurants, :est_duration_confidence, :integer
  end
end
