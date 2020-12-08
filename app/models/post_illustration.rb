# encoding: utf-8
class PostIllustration < Image
  mount_uploader :image, PostIllustrationUploader
  belongs_to :post

  attr_accessor :y, :y2, :x, :x2, :scale
  attr_accessible :y, :y2, :x, :x2, :scale

  default_scope include: :imageable

  def crop?
    x && y && x2 && y2 && scale
  end
end