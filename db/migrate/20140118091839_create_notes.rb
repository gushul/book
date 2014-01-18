class CreateNotes < ActiveRecord::Migration
  def change
    create_table(:notes) do |t|
      t.references :user
      t.references :restaurant
      t.string :phone
      t.text   :note
    end
    add_index :notes, :user_id
    add_index :notes, :restaurant_id
  end
end
