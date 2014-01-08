class AddPhoneWebsiteAddressToRestautants < ActiveRecord::Migration
  def change
    add_column :restaurants, :phone,   :string
    add_column :restaurants, :website, :string
    add_column :restaurants, :address, :string
  end
end
