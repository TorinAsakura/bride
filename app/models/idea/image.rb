class Idea::Image < ::Image
  mount_uploader :image, IdeaImageUploader

  def idea
    imageable
  end
end
