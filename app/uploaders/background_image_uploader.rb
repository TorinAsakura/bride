# encoding: utf-8
class BackgroundImageUploader < BaseImageUploader
  def store_dir
    "uploads/background_images/#{model.id}/"
  end

  process resize_to_limit: [2880, nil],  if: :header?
  process resize_to_limit: [8000, 10000], if: :background?

  version :thumb do
    process :resize_and_crop
  end

  version :preview do
    process resize_to_fill: [175, 175]
  end

  version :cell do
    process resize_to_fill: [80, 80]
  end

  def resize_and_crop
    manipulate! do |image|
      w_max = 2880
      w = image.columns
      w2 = w>w_max ? w_max : w
      h2 = 142
      image = image.resize_to_fit(w2,0)
      h = image.rows
      y = (h - h2).abs/2
      image = image.crop(0, y, w, h2)
      image
    end
  end

  protected
  def header?(img)
    model.header
  end

  def background?(img)
    !model.header
  end
end
