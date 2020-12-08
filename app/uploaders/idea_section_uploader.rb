# encoding: utf-8
class IdeaSectionUploader < BaseImageUploader
  def store_dir
    "uploads/ideas/sections/#{model.id}"
  end

  version :thumb do
    process resize_and_crop: [205, 205]
  end

  version :gray_thumb, from_version: :thumb do
    process make_gray: nil
  end

  def make_gray
    manipulate! format: "png" do |source|
      source.quantize(256, Magick::GRAYColorspace).colorize(0.65, 0.65, 0.65, '#ffffff')
    end
  end

  def resize_and_crop(width, height)
    manipulate! do |image|
      w = image.columns
      h = image.rows
      if h >= w
        image = image.resize_to_fit(width, 0)
        image = image.crop(0, 0, width, height)
      else
        image = image.resize_to_fit(0, height)
        w = image.columns
        x = (w - width).abs/2
        image = image.crop(x, 0, width, height)
      end
      image
    end
  end
end
