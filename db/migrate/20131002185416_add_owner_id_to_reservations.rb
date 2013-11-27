class AddOwnerIdToReservations < ActiveRecord::Migration
  def change
     add_column :reservations, :owner_id,  :integer
  end
end
