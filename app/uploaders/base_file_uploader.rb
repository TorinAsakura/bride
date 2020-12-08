# encoding: utf-8
class BaseFileUploader < CarrierWave::Uploader::Base
  storage :fog

  def extension_white_list
    %w(rar doc xls pdf docx)
  end

  def filename
    if original_filename.present?
      I18n.transliterate(original_filename).downcase.gsub(/\s/,"_")
    end
  end
end