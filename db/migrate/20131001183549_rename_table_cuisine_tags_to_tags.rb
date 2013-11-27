class RenameTableCuisineTagsToTags < ActiveRecord::Migration
 def self.up
    rename_table :cuisine_tags,             :restaurant_tags
    rename_table :cuisine_tags_restaurants, :restaurant_tags_restaurants
    
    rename_column :restaurant_tags_restaurants, :cuisine_tag_id, :restaurant_tag_id
  end

 def self.down
    rename_table :restaurant_tags,             :cuisine_tags
    rename_table :restaurant_tags_restaurants, :cuisine_tags_restaurants
    
    rename_column :cuisine_tags_restaurants, :restaurant_tag_id, :cuisine_tag_id
 end
end
