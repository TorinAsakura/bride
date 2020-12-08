# encoding: utf-8
class MessageImageUploader < BaseImageUploader
  def store_dir
    "uploads/messages/#{model.imageable.id}/"
  end

  version :thumb do
    process :resize_to_fill => [300, 150]
  end
end
