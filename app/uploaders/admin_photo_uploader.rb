# encoding: utf-8
class AdminPhotoUploader < BaseImageUploader
  def store_dir
    "uploads/admin_photo/#{model.id}"
  end

  def default_url
    ActionController::Base.helpers.asset_path('avatar.gif')
  end

  version :usual do
    process resize_to_fill: [200, 200]
  end

  version :preview do
    process resize_to_fill: [80, 80]
  end

  version :thumb do
    process resize_to_fill: [160, 160]
  end
end
