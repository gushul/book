# encoding: utf-8
class Restaurant < ActiveRecord::Base

  attr_accessible :lat, :lng, :misc, 
                  :name, :owner_id,
                  :restaurant_tags_attributes,
                  :days_in_advance, :min_booking_time, :res_duration,
                  :restaurant_tag_ids,
                  :photos_attributes, :largest_table,
                  :mon, :tue, :wed, :thu, :fri, :sat, :sun
 
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
  has_many :inventory_template_groups, :dependent => :destroy
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

  def self.generate_schedule
    puts "-------CRON----------"

    @intervals = []
      24.times do |h| 
        4.times do |m| 
            if h<10 and m!=0
              @intervals << "0#{h}:#{m*15}" 
            elsif h<10 and m==0
              @intervals << "0#{h}:00" 
            elsif h>=10 and m!=0
              @intervals << "#{h}:#{m*15}" 
            elsif h>=10 and m==0
              @intervals << "#{h}:0#{m*15}" 
            else
              @intervals << "#{h}:#{m*15}" 
            end
        end
      end
    @intervals << "24:00"

    Restaurant.all.each do |r|
    # r = Restaurant.first
      # puts r.inventory_template_groups.count
      
      # count of needed days
      # inv_cnt_have = r.inventories.where("date >= ?", Date.today).count
      created_count = 0
      inv_cnt_have = r.inventories.unscoped.where("date >= ?", Date.today).group(:date).length
      cnt = r.days_in_advance - inv_cnt_have
      
      puts "*************"
      puts "#{r.name}"
      # puts "#{r.days_in_advance}: r.days_in_advance"
      # puts "#{cnt}: r.days_in_advance - inv_cnt_have"
      # puts "*************"

      if cnt >= 0 
        # end_date = Date.today + r.days_in_advance.days
        end_date = DateTime.now.to_date + r.days_in_advance.days
        start_date = end_date - cnt
        period = 1
        dates = start_date.step(end_date, period).map.each_cons(1).to_a

        dates.each do |d|
          unless r.inventory_template_groups.blank?
            it = r.inventory_template_groups.first.inventory_templates
            it.each do |inv|
              Inventory.create(date: d.to_s, 
                               quantity_available: inv.quantity_available, 
                               start_time: inv.start_time, 
                               end_time: inv.end_time, 
                               restaurant_id: Restaurant.first.id)
              created_count += 1
            end
          end
        end
      end
      puts "#{created_count} inventories created"
    end
  end

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

   