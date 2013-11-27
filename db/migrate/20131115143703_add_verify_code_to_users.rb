class AddVerifyCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :verify_code, :integer
    add_column :users, :verified,    :boolean, :default => false, :null => false
  end
end
