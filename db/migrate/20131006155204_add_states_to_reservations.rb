class AddStatesToReservations < ActiveRecord::Migration
  def change
   change_table(:reservations) do |t|
      t.boolean :no_show, :default => false, :null => false
      t.boolean :arrived, :default => false, :null => false
      t.text    :table
    end
  end
end
