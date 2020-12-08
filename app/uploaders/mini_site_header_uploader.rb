# encoding: utf-8
class MiniSiteHeaderUploader < BaseImageUploader
  process resize_to_limit: [8000, 141]

  version :preview do
    process resize_to_fill: [800, 141]
  end

  def store_dir
    "uploads/mini_site_headers/#{model.id}"
  end
end
