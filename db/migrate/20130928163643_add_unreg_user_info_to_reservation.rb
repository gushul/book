class AddUnregUserInfoToReservation < ActiveRecord::Migration
  def change
    add_column :reservations, :name,  :string
    add_column :reservations, :email, :string
    add_column :reservations, :phone, :string
  end
end
