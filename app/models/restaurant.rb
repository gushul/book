# encoding: utf-8
class Restaurant < ActiveRecord::Base
  paginates_per 10
  
  attr_accessible :lat, :lng, :misc, 
                  :name, :owner_id,
                  :restaurant_tags_attributes,
                  :days_in_advance, :min_booking_time, :res_duration,
                  :restaurant_tag_ids,
                  :photos_attributes, :largest_table,
                  :mon, :tue, :wed, :thu, :fri, :sat, :sun,
                  :phone, :address, :th_address, :website,
                  :est_duration_confidence, :est_duration
 
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

  has_many :nicknames,            :dependent => :destroy
  has_many :vips,                :dependent => :destroy
  has_many :notes,               :dependent => :destroy
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

  scope :by_ids_and_tags, lambda { |ids, tag_ids|
    restaurants = Restaurant.by_ids(ids)
    restaurants.map! { |r| r.restaurant_tags.where("id in (?)", tag_ids).blank? ? nil : r }
    restaurants.compact
  }

  scope :by_ids, lambda { |ids|
    where('id in (?)',  ids )
  }

  scope :by_date_time_people, lambda { |date, time, people|
    joins(:inventories).where('inventories.date = ? AND inventories.start_time = ? AND inventories.quantity_available >= ?', date, "2000-01-01 #{time}:00", people)
  }

  def get_text_tags_by_group(group)
    self.restaurant_tags.where("title LIKE ?", "#{group}:%").map{|t| t.title.gsub( /.*:/, "" ) }
  end

  def self.generate_schedule
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
      inv_cnt_have = r.inventories.where("date >= ?", Date.today).group(:date).length
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
            r.inventory_template_groups.each do |itg|
              it = itg.inventory_templates
              it.each do |inv|
                Inventory.create(date: d.to_s, 
                                 quantity_available: inv.quantity_available, 
                                 start_time: inv.start_time, 
                                 end_time: inv.end_time, 
                                 restaurant_id: r.id)
                created_count += 1
              end
            end
          end
        end
      end
      puts "#{created_count} inventories created"
    end
  end

  def earliest_time
    inv = self.inventories.by_date.first
    unless inv.blank?
      return inv.start_time.strftime("%H%M")
    end
    "No inventories today"
  end

  def latest_time
    inv = self.inventories.by_date.last
    unless inv.blank?
      time = inv.end_time - res_duration.minutes
      return time.strftime("%H%M")
    end
    "No inventories today"
  end

  def check_availability(date, time, people)
    if self.inventories.where('date = ? AND start_time = ? AND quantity_available >= ?', date, "2000-01-01 #{time}:00", people)
      return true
    end
    false
  end

  def it_quantities
    @quantity = []
    4.times {|i| @quantity[i] = []}
    self.inventory_template_groups.each do |itg|
      itg.inventory_templates.each do |inv|

          m1 = inv.start_time.strftime("%M").to_i
          m1 == 0 ? 0 : m1 = m1/15
          m2 = inv.end_time.strftime("%M").to_i
          m2 == 0 ? 0 : m2 = m2/15
          h1 = inv.start_time.strftime("%H").to_i
          h2 = inv.end_time.strftime("%H").to_i
          # works only for 15 min inventory_templates 
          if h1 == h2 and (m2 - m1) > 0
            (m2 - m1).times {|t| @quantity[m1+t][h1] = inv.quantity_available }
          elsif h1 != h2
            (h2 - h1 + 1).times do |th| 
              unless th == h2 - h1
                4.times {|tm| 
                  @quantity[tm - m1][h1 + th] = inv.quantity_available 
                }
              else
                (m2 - m1).times {|tm| 
                  @quantity[m1 + tm][h1 + th] = inv.quantity_available }
              end
            end
          end

      end
    end
    @quantity
  end

  def location_format
    tag = restaurant_tags.where("title LIKE ?", "Location:%").first
    unless tag.blank?
      return tag.title.slice(9..tag.title.length)
    end
    "None"
  end

  def parking_format
    tag = restaurant_tags.where("title LIKE ?", "Parking:%").first
    unless tag.blank?
      return tag.title.slice(8..tag.title.length)
    end
    "No"
  end

  def price_format
    tag = restaurant_tags.where("title LIKE ?", "Price:%").first
    unless tag.blank?
      return tag.title.slice(6..tag.title.length).length
    end
    0
  end

  def price_desc
    tag = restaurant_tags.where("title LIKE ?", "Price:%").first
    unless tag.blank?
      price = tag.title.slice(6..tag.title.length).length
      if price == 1 
        price = "100 - 400 Baht"
      elsif price == 2
        price = "400 - 700 Baht"
      elsif price == 3
        price = "700 - 1000 Baht"
      else
        price = "> 1000 Baht"
      end
      return price
    end
    0
  end

  def cuisines_format
    tag = restaurant_tags.where("title LIKE ?", "Cuisine:%")
    unless tag.blank?
      return tag.map {|r| r.title.slice(8..r.title.length) }.join(", ")
    end
    "No yet assigned any cuisine"
  end

  def drinks_format
    tag = restaurant_tags.where("title LIKE ?", "Drinking:%")
    unless tag.blank?
      return tag.map {|r| r.title.slice(9..r.title.length) }.join(", ")
    end
    "None"
  end

  def star_format
    tag = restaurant_tags.where("title LIKE ?", "Star:%").first
    unless tag.blank?
      return tag.title.slice(5..tag.title.length).to_i
    end
    0
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

   