class AddRedeemedToRewards < ActiveRecord::Migration
  def change
    add_column :rewards, :redeemed, :boolean, :default => false
  end
end
