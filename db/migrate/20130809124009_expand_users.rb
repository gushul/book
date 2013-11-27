class ExpandUsers < ActiveRecord::Migration
  def change
     change_table(:users) do |t|
       t.string :username
       t.string :phone
     end
  end
end
