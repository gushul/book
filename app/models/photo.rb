# encoding: utf-8
# require 'file_size_validator'
class Photo < ActiveRecord::Base

  attr_accessible :title, :picture, :is_cover, :restaurant_id

  mount_uploader :picture, PhotoUploader

  belongs_to :restaurant

  #validates :picture, :presence => true#,
  #   :file_size => {
  #   :maximum => 10.megabytes.to_i
  # }

  # before_save :cover_controll
  
  scope :by_date, -> {order('created_at DESC')}

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

  # private

  # def cover_controll
  #   # если первая картинка в альбоме
  #   if new_record? && !is_cover? && brothers.blank?
  #     self.is_cover = true
  #   elsif !changes.blank? && !changes['is_cover'].blank? && is_cover?
  #     # если картинку помечают как обложка, то старые обложки помечаем как НЕ обложка :)
  #     photo_album.photos.update_all :is_cover => false
  #   end
  # end
end
