# encoding: utf-8
class PostImageUploader < BaseImageUploader
  def store_dir
    "uploads/posts/#{model.imageable.id}/"
  end

  version :cover do
    process resize_to_fill: [320, 160]
  end

  version :large_preview do
    process resize_to_fill: [320, 320]
  end
end
