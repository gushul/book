class AddThAddressToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :th_address, :string
  end
end
