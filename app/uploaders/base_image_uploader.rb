# encoding: utf-8
class BaseImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    if original_filename.present?
      I18n.transliterate(original_filename).downcase.gsub(/\s/,"_")
    end
  end
end