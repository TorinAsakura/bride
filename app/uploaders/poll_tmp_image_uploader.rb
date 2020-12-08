# encoding: utf-8
class PollTmpImageUploader < BaseImageUploader
  def store_dir
    "uploads/polls_tmp/#{model.class.name}/#{model.id}/"
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
end
