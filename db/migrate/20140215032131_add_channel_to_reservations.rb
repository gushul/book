class AddChannelToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :channel, :integer, :default => 0
  end
end
