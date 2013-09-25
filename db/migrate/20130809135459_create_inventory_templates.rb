class CreateInventoryTemplates < ActiveRecord::Migration
  def change
    create_table :inventory_templates do |t|
      t.references :restaurant
      t.string :name
      t.time :start_time
      t.time :end_time
      t.integer :quantity_available
      t.boolean :primary

      t.timestamps
    end
    add_index :inventory_templates, :restaurant_id
  end
end
