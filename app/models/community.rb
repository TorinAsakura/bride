# encoding: utf-8
class Community < ActiveRecord::Base
  resourcify

  attr_accessible :avatar, :description, :name, :avatar_x, :avatar_y, :avatar_x2, :avatar_y2, 
                  :avatar_scale, :community_category_id, :rules, :logo
  attr_accessor :avatar_x, :avatar_y, :avatar_x2, :avatar_y2, :avatar_scale

  mount_uploader :avatar, CommunityAvatarUploader
  mount_uploader :logo,   CommunityLogoUploader

  has_many :albums, as: :resource
  has_many :photos, through: :albums
  has_many :images, through: :posts, order: 'id DESC'
  has_many :posts, as: :journal, dependent: :destroy
  has_many :videos, class_name: 'MediaContent', as: :multimedia, conditions: 'media_contents.video = true'
  has_many :post_categories, class_name: 'CommunityPostCategory'

  belongs_to :community_category

  has_and_belongs_to_many :clients

  validates :name, presence: true

  def join_the_community(client)
    self.clients << client
    client.user.add_role :member, self
  end

  def leave_the_community(client)
    self.clients.delete(client)
    client.user.remove_role :member, self
  end

  def add_moderator(user)
    if user.client? && self.client_ids.include?(user.client.id)
      user.add_role :request_moderator, self
    end
  end

  def deny_moderator(user)
    user.remove_role :request_moderator, self
    user.remove_role :moderator, self
  end

  def confirm_moderator(user)
    user.remove_role :request_moderator, self
    user.add_role :moderator, self
  end

  def full_name
    self.name
  end

  def root_object
    self
  end

  def update_avatar
    if avatar
      avatar.cache_stored_file!
      avatar.retrieve_from_cache!(avatar.cache_name)
      avatar.recreate_versions! :usual
      save!
    end
  end

  def jcrop_resize?
    avatar_x && avatar_y && avatar_x2 && avatar_y2 && avatar_scale
  end

  def can_edit?(user)
    true
  end
end
