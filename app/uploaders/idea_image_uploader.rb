# encoding: utf-8
class IdeaImageUploader < BaseImageUploader
  def store_dir
    'uploads/ideas/images/'
  end

  def default_url
    ActionController::Base.helpers.asset_path('avatar.gif')
  end

  process resize_to_fit: [650, 750]

  version :thumb do
    process resize_to_fit: [230, 0]
  end

  version :preview do
    process resize_to_fill: [160, 160]
  end

  def filename
    "#{model.imageable.id}_#{I18n.transliterate(original_filename.gsub("#{model.imageable.id}_", '')).downcase.gsub(/\s/,"_")}" if original_filename.present?
  end
end
