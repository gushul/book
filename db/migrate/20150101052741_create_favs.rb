class CreateFavs < ActiveRecord::Migration
  def change
    create_table :favs do |t|
      t.integer :user_id
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
