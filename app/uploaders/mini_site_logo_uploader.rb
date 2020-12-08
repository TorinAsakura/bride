# encoding: utf-8
class MiniSiteLogoUploader < BaseImageUploader
  def store_dir
    "uploads/avatars/mini_site_logo/#{model.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path('avatar.gif')
  end

  version :about do
    process resize_to_limit: [645, nil]
  end

  version :preview do
    process resize_to_fill: [460, 250]
  end

  version :scheduler do
    process resize_to_limit: [300, nil]
  end

  version :thumb do
    process resize_to_fill: [80, 80]
  end
end
