class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string  :title
      t.string  :picture
      t.integer :restaurant_id
      t.boolean :is_cover

      t.timestamps
    end
  end
end
