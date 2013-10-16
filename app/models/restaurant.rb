# encoding: utf-8
class Restaurant < ActiveRecord::Base

  attr_accessible :category, :lat, :lng, :misc, 
                  :name, :owner_id, :price,
                  :restaurant_tags_attributes,
                  :days_in_advance, :min_booking_time, :res_duration,
                  :cuisine_list, :restaurant_tag_ids,
                  :photos_attributes, :largest_table
 
  validates :name,  :presence => true
  validates :lng,   :presence => true
  validates :lat,   :presence => true
  # validates :price, :presence => true

  validates :days_in_advance,  :presence    => true, 
                :numericality => { 
                  :greater_than_or_equal_to => 0, 
                  :less_than_or_equal_to    => 180 }
  validates :min_booking_time, :presence    => true,
                :numericality => { 
                  :greater_than_or_equal_to => 15, 
                  :less_than_or_equal_to    => 720 }
  validates :res_duration,     :presence    => true, 
                :numericality => { 
                  :greater_than_or_equal_to => 15, 
                  :less_than_or_equal_to    => 720 }

  validates :largest_table,    :presence    => true, 
                :numericality => { 
                  :greater_than_or_equal_to => 1 }
  
  # validates :price, :numericality => { 
  #                 :greater_than_or_equal_to => 1, 
  #                 :less_than_or_equal_to    => 5   }

  has_many :photos,              :dependent => :destroy
  has_many :reservations,        :dependent => :destroy
  has_many :inventories,         :dependent => :destroy
  has_many :inventory_templates, :dependent => :destroy
  has_and_belongs_to_many :restaurant_tags

  accepts_nested_attributes_for :restaurant_tags, :allow_destroy => :true,
          :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  accepts_nested_attributes_for :photos, 
                                reject_if: :all_blank,
                                allow_destroy: true   
  belongs_to :owner
    
  scope :by_tags, lambda { |ids|
    ids.collect {|i| joins(:restaurant_tags).where('restaurant_tags.id = ?', i ) }.flatten
  }

# private

#   def cover_controll
#     # if first pic of the restaurant hence cover
#     if new_record? && !is_cover? && brothers.blank?
#       self.is_cover = true
#     elsif !changes.blank? && !changes['is_cover'].blank? && is_cover?
#       # if pic marked as cover hence all other pictures not cover
#       photo_album.photos.update_all :is_cover => false
#     end
#   end
    
end

   