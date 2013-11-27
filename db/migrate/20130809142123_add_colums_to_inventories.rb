class AddColumsToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :start_time, :time
    add_column :inventories, :end_time, :time
    add_column :inventories, :quantity_available, :integer
  end
end
