class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.references :user
      t.references :reservation
      t.integer :points_total
      t.integer :points_pending
      t.text :description

      t.timestamps
    end
  end
end
