class AddPhoneToNicknames < ActiveRecord::Migration
  def change
    add_column :nicknames, :phone, :string
  end
end
