# encoding: utf-8
class WishlistImage < Image
  mount_uploader :image, WishlistImageUploader
  belongs_to :whishlist
end
