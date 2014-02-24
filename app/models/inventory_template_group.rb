class InventoryTemplateGroup < ActiveRecord::Base
  paginates_per 20
  
  attr_accessible :name, :primary, :restaurant, :quantity_available
 
  validates :restaurant_id,      :presence => true
  validates :name,               :presence => true
 
  belongs_to :restaurant
  has_many   :inventory_templates, :dependent => :destroy

  def quantity_available
  end

  def quantity_available=(value)
  end

end
