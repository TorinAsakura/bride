# encoding: utf-8
class AvatarUploader < BaseImageUploader
  def store_dir
    "uploads/avatars/#{model.class.name}/#{model.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path("placeholders/"+["#{model.gender ? 'fiance' : 'fiancee'}", version_name].compact.join('/') +".png")
  end

  process resize_to_limit: [760, 700]

  version :usual do
    process :jcrop_resize
    process resize_to_fill: [278, 302]
  end

  version :thumb do
    process :jcrop_resize
    process resize_to_fill: [95, 95]
  end

  version :icon do
    process :jcrop_resize
    process resize_to_fill: [150, 150]
  end

  version :small do
    process :jcrop_resize
    process resize_to_fill: [50, 50]
  end

  private
  def jcrop_resize
    if model.jcrop_resize?
      scale = model.avatar_scale.to_d
      x = model.avatar_x.to_d * scale
      y = model.avatar_y.to_d * scale
      x2 = model.avatar_x2.to_d * scale
      y2 = model.avatar_y2.to_d * scale

      manipulate! do |img|
        img.crop(x, y, x2 - x, y2 - y)
      end
    end
  end
end
