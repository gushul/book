class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :user
      t.references :restaurant
      t.date :date
      t.time :start_time
      t.time :end_time
      t.integer :party_size
      t.boolean :active

      t.timestamps
    end
    add_index :reservations, :user_id
    add_index :reservations, :restaurant_id
  end
end
