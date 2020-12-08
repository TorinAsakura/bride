# encoding: utf-8
class Photo < ActiveRecord::Base

  belongs_to :album, foreign_key: 'photo_album_id', counter_cache: true
  attr_accessible :title, :description, :path, :tag_ids, :banner_path, :usual_path,
                  :photo_album_id, :link, :banner_x, :banner_y, :banner_x2, :banner_y2,
                  :banner_scale, :initial_album_id, :banner
  attr_accessor :banner_x, :banner_y, :banner_x2, :banner_y2, :banner_scale

  mount_uploader :usual_path, UserPhotoUploader
  mount_uploader :banner_path, FirmBannerUploader

  acts_as_votable
  acts_as_taggable
  acts_as_commentable

  DEPTH = 2

  has_many :complaints, :as => :pretension, :dependent => :destroy

  scope :ordered, ->{order('id desc')}

  paginates_per 15

  after_destroy do
    if self.is_cover?
      self.album.update_attributes({cover_id: nil})
    end
  end

  before_create do
    self.initial_album_id = album.id
  end

  def is_cover?
    self.album.cover_id == self.id
  end

  def owner?(user)
    self.album.resource.owner?(user)
  end

  def path# if you didn't know - banner or usual
    return self.banner_path if self.banner_path.url
    return self.usual_path if self.usual_path.url
    #because uploder didn't return nill
  end

  def uploader
    self.album.firm || self.album.resource
    # banner || usual
  end

  def root_object
    album.try(:root_object)
  end

  def jcrop_resize?
    banner_x && banner_y && banner_x2 && banner_y2 && banner_scale
  end

  def next_photo
    album.photos.where('id < ?', id).order('id DESC').first || album.photos.first(order: 'id DESC')
  end

  def prev_photo
    album.photos.where('id > ?', id).order('id ASC').last || album.photos.last(order: 'id ASC')
  end
end
