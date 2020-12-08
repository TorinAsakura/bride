# encoding: utf-8
class MiniSiteBackgroundUploader < BaseImageUploader
  process resize_to_limit: [8000, 10000]

  version :preview do
    process resize_to_fill: [800, 1000]
  end

  version :thumb do
    process resize_to_fill: [160, 160]
  end

  def store_dir
    "uploads/mini_site_backgrounds/#{model.id}"
  end
end
