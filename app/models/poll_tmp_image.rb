class PollTmpImage < ActiveRecord::Base
  # attr_accessible :title, :body
  mount_uploader :image, PollTmpImageUploader
end
