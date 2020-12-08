class CommunityCategory < ActiveRecord::Base
  default_scope order('position')
  attr_accessible :description, :logo, :title, :avatar
  mount_uploader :avatar, CommunityCategoryAvatarUploader

  has_many :communities, order: 'position'
end
