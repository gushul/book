# encoding: utf-8
class Photo < ActiveRecord::Base

  attr_accessible :title, :picture, :is_cover, :restaurant_id

  mount_uploader :picture, PhotoUploader

  belongs_to :restaurant

  #validates :picture, :presence => true#,
  #   :file_size => {
  #   :maximum => 10.megabytes.to_i
  # }

  before_validation :default_value
  before_save :cover_controll
  after_destroy :cover_controll_2
  
  default_scope order('created_at DESC')
  # scope :by_date, -> {order('created_at DESC')}
  scope :covers,    -> { where(is_cover: true) }
  scope :no_covers, -> { where(is_cover: false) }

  # def cover!
  #   self.update_attributes :is_cover => true
  # end

  # class << self
  #   def remove_unused_attachments
  #     self.where(self.object_field => nil).where('created_at < ?', 1.day.ago).destroy_all
  #   end

  #   def object
  #     'photo_album'
  #   end

  #   def object_field
  #     'photo_album_id'
  #   end

  #   def file_field
  #     'picture'
  #   end

  #   def additional_fields
  #     []# ['title']
  #   end
  # end

  # # все фотки из альбома текущей фотки
  # def brothers
  #   @brothers ||= photo_album ? photo_album.photos : Photo.of_code(object_code)
  # end

  # def brothers_without_me
  #   @brothers_without_me ||= brothers.where('id <> ?', id)
  # end

private

  def default_value
    if Photo.where(restaurant_id: restaurant_id).present? 
      self.is_cover ||= false
    else
      self.is_cover ||= true
    end
  end

  def cover_controll
    if Photo.where(restaurant_id: restaurant_id).present?  && is_cover?
      Photo.update_all(is_cover: false)
      self.is_cover = true
    end
  end

  def cover_controll_2
    if Photo.where(restaurant_id: restaurant_id).covers.blank?
      photo = Photo.where(restaurant_id: restaurant_id).first
      photo.update_attributes(is_cover: true) if photo.present?
    end
  end
  
end
