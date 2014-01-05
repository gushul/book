class CreateVips < ActiveRecord::Migration
  def change
    create_table(:vips) do |t|
      t.references :user
      t.references :restaurant
      t.string :name
      t.string :phone
    end
    add_index :vips, :user_id
    add_index :vips, :restaurant_id
  end
end
