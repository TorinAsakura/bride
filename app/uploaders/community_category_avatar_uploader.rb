# encoding: utf-8
class CommunityCategoryAvatarUploader < BaseImageUploader
  def store_dir
    "uploads/community_categories_avatars/#{model.id}/"
  end

  def default_url
    ActionController::Base.helpers.asset_path('avatar.gif')
  end

  version :preview do
    process resize_to_fill: [110, 110]
  end
end
