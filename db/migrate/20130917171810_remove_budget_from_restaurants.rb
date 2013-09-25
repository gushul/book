class RemoveBudgetFromRestaurants < ActiveRecord::Migration
  def change
    remove_column :restaurants, :budget
  end
end
