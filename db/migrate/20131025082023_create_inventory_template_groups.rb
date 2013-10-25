class CreateInventoryTemplateGroups < ActiveRecord::Migration
  def change
    create_table :inventory_template_groups do |t|
      t.string :name
      t.boolean :primary
      t.references :restaurant

      t.timestamps
    end
    
    add_index :inventory_template_groups, :restaurant_id

  end
end
