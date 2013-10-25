class AddInvTmplGroupToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :mon, :integer
    add_column :restaurants, :tue, :integer
    add_column :restaurants, :wed, :integer
    add_column :restaurants, :thu, :integer
    add_column :restaurants, :fri, :integer
    add_column :restaurants, :sat, :integer
    add_column :restaurants, :sun, :integer
  end
end
