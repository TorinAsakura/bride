# encoding: utf-8
class CommentImageUploader < BaseImageUploader
  version :preview do
    process resize_to_fill: [300, 150]
  end

  def store_dir
    "uploads/comments/#{model.imageable.commentable_type}/#{model.imageable.commentable_id}/items/#{model.id}/"
  end
end
