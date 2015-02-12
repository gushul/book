class AddMyRCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :my_r_code, :string
  end
end
