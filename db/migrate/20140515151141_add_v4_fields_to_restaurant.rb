class AddV4FieldsToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :days_out_allow_booking,    :string
    add_column :restaurants, :min_in_adv_bookings_close, :string
    add_column :restaurants, :avg_turn_time,             :string
    add_column :restaurants, :conf_in_avg_turn_time,     :string
    add_column :restaurants, :max_turn_time,             :string
  end
end
