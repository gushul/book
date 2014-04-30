# encoding: utf-8
class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :file

  def default_url
     "/assets/no-pic/photos/photo-#{version_name}.png"
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # version :v270x150v2 do
  #   process :resize_and_pad => [270, 150, :transparent, ::Magick::CenterGravity]
  # end

  version :v600x480 do
    process :resize_to_fit => [600, 480]#, ::Magick::CenterGravity]
  end
  
  version :v280x160 do
    process :resize_to_fit => [280, 160]#, ::Magick::CenterGravity]
  end

  version :v100x100 do
    process :resize_and_pad => [100, 100, :transparent, ::Magick::CenterGravity]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
