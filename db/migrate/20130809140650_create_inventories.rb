class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.references :restaurant
      t.date :date

      t.timestamps
    end
    add_index :inventories, :restaurant_id
  end
end
