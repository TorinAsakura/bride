# encoding: utf-8
class FirmLogoUploader < BaseImageUploader
  def store_dir
    "uploads/avatars/firms_logo/#{model.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path('firms/'+[version_name, 'site_logo.jpg'].compact.join('_'))
  end

  version :usual do
    process :jcrop_resize
    process resize_to_fill: [200, 200]
  end

  version :thumb do
    process :jcrop_resize
    process resize_to_fill: [95, 95]
  end

  version :small do
    process :jcrop_resize
    process resize_to_fill: [50, 50]
  end

  private
  def jcrop_resize
    if model.jcrop_resize?
      scale = model.logo_scale.to_d
      x = model.logo_x.to_d * scale
      y = model.logo_y.to_d * scale
      x2 = model.logo_x2.to_d * scale
      y2 = model.logo_y2.to_d * scale

      manipulate! do |img|
        img.crop(x, y, x2 - x, y2 - y)
      end
    end
  end
end
