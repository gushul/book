class ExpandOwners < ActiveRecord::Migration
   def change
     change_table(:owners) do |t|
       t.string :owner_name
       t.string :phone
     end
  end
end
