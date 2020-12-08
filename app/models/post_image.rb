# encoding: utf-8
class PostImage < Image
  mount_uploader :image, PostImageUploader
  belongs_to :post
  validates :image, presence: true

  paginates_per 15
  acts_as_votable
end
