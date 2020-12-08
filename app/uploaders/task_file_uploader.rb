# encoding: utf-8
class TaskFileUploader < BaseFileUploader
  def store_dir
    "uploads/task/#{mounted_as}/#{model.id}"
  end
end
