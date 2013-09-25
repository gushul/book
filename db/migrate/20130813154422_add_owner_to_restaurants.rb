class AddOwnerToRestaurants < ActiveRecord::Migration
  def change
    change_table(:restaurants) do |t|
      t.references :owner
    end
  end
end
