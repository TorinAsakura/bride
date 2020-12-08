# encoding: utf-8
class PrizePictureUploader < BaseImageUploader
  def store_dir
    "uploads/competitions/#{model.competition_id}/prizes/#{model.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path('avatar.gif')
  end

  process :resize_to_limit => [200, 200]

  version :thumb do
    process :resize_to_fill => [100, 100]
  end
end
