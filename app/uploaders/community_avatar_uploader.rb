# encoding: utf-8
class CommunityAvatarUploader < BaseImageUploader
  def store_dir
    "uploads/communities_avatars/#{model.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path('avatar.gif')
  end

  version :thumb do
    process :jcrop_resize
    process resize_to_limit: [300, nil]
  end

  version :preview do
    process :jcrop_resize
    process resize_to_fill: [110, 110]
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
