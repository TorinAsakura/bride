# encoding: utf-8
class UserPhotoUploader < BaseImageUploader
  def store_dir
    "uploads/photo/albums/#{model.album.resource_type}/#{model.album.resource_id}/#{model.initial_album_id}/items/#{model.id}/"
  end

  process resize_to_limit: [800, 10000]

  version :large_preview do
    process resize_and_crop: [320, 320]
  end

  version :preview, from_version: :large_preview do
    process resize_to_fill: [160, 160]
  end

  version :card, from_version: :large_preview do
    process resize_to_fill: [150, 150]
  end

  version :cover, from_version: :large_preview do
    process resize_and_crop: [320, 160]
  end

  def resize_and_crop(width, height)
    manipulate! do |image|
      w = image.columns
      h = image.rows
      if h >= w
        image = image.resize_to_fit(width, 0)
        image = image.crop(0, 0, width, height)
      else
        image = image.resize_to_fit(0, height)
        w = image.columns
        x = (w - width).abs/2
        image = image.crop(x, 0, width, height)
      end
      image
    end
  end
end
