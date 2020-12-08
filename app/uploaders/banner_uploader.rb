# encoding: utf-8
class BannerUploader < BaseImageUploader
  def store_dir
    "uploads/banners/#{model.id}/"
  end

  process resize_to_fill: [960, 360]

  version :thumb do
    process resize_to_fill: [192, 72]
  end
end
