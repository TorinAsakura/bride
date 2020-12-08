# encoding: utf-8
class WishlistImageUploader < BaseImageUploader
  def store_dir
    "uploads/wishlist/#{model.imageable.id}"
  end

  version :thumb do
    process resize_to_fill: [160, 160]
  end
end
