# encoding: utf-8
#TODO refactor ICON, what is this?
class IconUploader < BaseImageUploader
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :resize_to_fit => [50, 50]
end
