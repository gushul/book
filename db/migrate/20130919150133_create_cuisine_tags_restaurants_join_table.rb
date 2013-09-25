class CreateCuisineTagsRestaurantsJoinTable < ActiveRecord::Migration
  def change
    create_table :cuisine_tags_restaurants, :id => false do |t|
      t.integer :cuisine_tag_id
      t.integer :restaurant_id
    end
  end
end
