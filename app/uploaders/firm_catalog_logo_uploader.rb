# encoding: utf-8
class FirmCatalogLogoUploader < BaseImageUploader
  def store_dir
    "uploads/firm_catalogs/#{model.id}"
  end

  version :thumb do
    process :jcrop_resize
    process resize_to_fit: [488, 686]
  end

  private
  def jcrop_resize
    if model.jcrop_resize?
      scale = model.logo_scale.to_d
      x =  model.logo_x.to_d  * scale
      y =  model.logo_y.to_d  * scale
      x2 = model.logo_x2.to_d * scale
      y2 = model.logo_y2.to_d * scale

      manipulate! do |img|
        img.crop(x, y, x2 - x, y2 - y)
      end
    end
  end
end
