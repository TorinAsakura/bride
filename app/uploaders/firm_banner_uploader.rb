# encoding: utf-8
class FirmBannerUploader < BaseImageUploader
  def store_dir
    "uploads/photo/Firm/#{model.album.firm.id}/banners/#{model.id}/"
  end

  version :usual do
    process :jcrop_resize
    process :resize_to_fill => [650, 200]
  end

  version :thumb do
    process :jcrop_resize
    process :resize_to_fill => [80, 80]
  end

  private
  def jcrop_resize
    if model.jcrop_resize?
      scale = model.banner_scale.to_d
      x = model.banner_x.to_d * scale
      y = model.banner_y.to_d * scale
      x2 = model.banner_x2.to_d * scale
      y2 = model.banner_y2.to_d * scale

      manipulate! do |img|
        img.crop(x, y, x2 - x, y2 - y)
      end
    end
  end
end
