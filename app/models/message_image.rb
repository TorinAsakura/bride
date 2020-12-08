# encoding: utf-8
class MessageImage < Image
  mount_uploader :image, MessageImageUploader
  belongs_to :message
  attr_accessible :imageable_id
end
