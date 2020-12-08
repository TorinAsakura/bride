# encoding: utf-8
class FirmPageImageUploader < BaseImageUploader
  def store_dir
    "uploads/firm_pages/#{model.imageable.id}/"
  end
end
