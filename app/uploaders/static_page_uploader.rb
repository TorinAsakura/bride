# encoding: utf-8
class StaticPageUploader < BaseImageUploader
  def store_dir
    "uploads/static_page_imgs/#{model.class.name}/#{model.id}/"
  end

  process :resize_to_fill => [150, 150]

  version :preview do
    process :resize_to_fill => [100,100]
  end

  version :thumb do
    process :resize_to_fill => [75, 75]
  end
end
