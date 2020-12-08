# encoding: utf-8
class UserCommentImage < Image
  mount_uploader :image, CommentImageUploader

  acts_as_votable

  def next_image
    if imageable.images.length > 1
      imageable.images.where('id < ?', id).order('id DESC').first || imageable.images.first(order: 'id DESC')
    else
      nil
    end
  end
end
