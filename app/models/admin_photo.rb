# encoding: utf-8
class AdminPhoto < ActiveRecord::Base
  attr_accessible :description, :path, :tag_list
  mount_uploader :path, AdminPhotoUploader

  acts_as_taggable

  validates :path, :description, :presence => true

  paginates_per 20
end
