class Idea::CategoryImage < ::Image
  mount_uploader :image, IdeaImageUploader

  def category
    imageable
  end
end
