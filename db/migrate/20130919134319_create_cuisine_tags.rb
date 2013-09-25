class CreateCuisineTags < ActiveRecord::Migration
  def change
    create_table :cuisine_tags do |t|
      t.string  :title

      t.timestamps
    end

  end
end
