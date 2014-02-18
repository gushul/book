class CreateNicknames < ActiveRecord::Migration
  def change
    create_table(:nicknames) do |t|
      t.string :nickname
      t.references :user
      t.references :restaurant
    end
    add_index :nicknames, :user_id
    add_index :nicknames, :restaurant_id
  end
end
