class AddCuisineAndBudgetToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :cuisine, :string
    add_column :restaurants, :budget, :string
  end
end
