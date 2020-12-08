# encoding: utf-8
class PostIllustrationUploader < BaseImageUploader
  def store_dir
    "uploads/posts/#{model.imageable.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path('sorted/sv-illustration-placeholder.png')
  end

  version :medium do
    process :manualcrop
    process :resize_to_fill => [323, 160]
  end

  version :icon do
    process :resize_to_fill => [150, 150]
  end

  #rewrite it without using double scale
  def manualcrop
    if model.crop?
      x = model.x.to_d
      y = model.y.to_d
      x2 = model.x2.to_d
      y2 = model.y2.to_d
      scale = model.scale.to_d

      manipulate! do |img|
        img = img.scale(1/scale)
        img = img.crop(x, y, x2-x, y2-y)
      end
    end
  end
end
