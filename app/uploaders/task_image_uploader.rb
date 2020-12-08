# encoding: utf-8
class TaskImageUploader < BaseImageUploader
  def store_dir
    "uploads/task/#{model.id}/"
  end

  version :thumb do
    process :manualcrop
    process resize_to_fill: [650, 200]
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
