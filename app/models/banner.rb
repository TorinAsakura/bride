# encoding: utf-8
class Banner < ActiveRecord::Base
  mount_uploader :image, BannerUploader

  attr_accessible :image, :title, :description, :banner_type, :link, :for_guests, :for_users, :for_firms

  validates :image, presence: true

  scope :system, -> { where(banner_type: 0).reorder('created_at DESC') }
  scope :ads,    -> { where(banner_type: 1).reorder('created_at DESC') }

  def system?
    self.banner_type == 0
  end

  def ad?
    self.banner_type == 1
  end
end
