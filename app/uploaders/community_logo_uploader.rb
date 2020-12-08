class CommunityLogoUploader < BaseImageUploader
  def store_dir
    "uploads/communities_logos/#{model.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path('avatar.gif')
  end

  version :preview do
    process resize_to_fill: [110, 110]
  end
end
