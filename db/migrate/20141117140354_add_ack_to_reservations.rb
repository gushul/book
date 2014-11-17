class AddAckToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :ack, :boolean, :default => false
  end
end
