class AddSpecialRequestsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :special_request, :text
  end
end
