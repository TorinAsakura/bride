# encoding: utf-8
 class PollImage < Image

  mount_uploader :image, PollUploader
  belongs_to :poll
  acts_as_votable

  validates :image, :presence => true
 end
