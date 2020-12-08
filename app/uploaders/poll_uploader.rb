# encoding: utf-8
class PollUploader < BaseImageUploader
  def store_dir
    'uploads/polls/'
  end

  version :thumb do
    process resize_to_fill: [206, 206]
  end

  version :preview_for_one_second do
    process resize_to_fill: [237, 250]
  end

  version :preview_for_one_third do
    process resize_to_fill: [158, 250]
  end

  version :poll do
    process resize_to_fit: [800, 464]
  end

  def filename
    "#{model.imageable.id}_#{I18n.transliterate(original_filename).downcase.gsub(/\s/,"_")}" if original_filename.present?
  end
end
