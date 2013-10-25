class InvTemplateOnInvTemplateGroupModification < ActiveRecord::Migration
  def change
    remove_column :inventory_templates, :primary
    remove_column :inventory_templates, :name
    remove_column :inventory_templates, :restaurant_id

    change_table(:inventory_templates) do |t|
      t.references :inventory_template_group
    end

  end
end
