class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string  :title
      t.string  :picture
      t.string  :restaurant_id
      t.string  :is_cover

      t.timestamps
    end
  end
end
