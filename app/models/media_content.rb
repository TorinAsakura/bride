# encoding: utf-8
class MediaContent < ActiveRecord::Base
  extend ModelExt::Paginates

  belongs_to :multimedia, polymorphic: true
  has_many :complaints, as: :pretension, dependent: :destroy
  has_many :favorites, as: :favoriteable

  acts_as_taggable
  acts_as_votable
  acts_as_commentable
  DEPTH = 2

  attr_accessible :content, :description, :title, :video, :tag_list, :status

  validates :content, :multimedia, presence: true

  scope :videos, -> { where("video IS NOT NULL AND multimedia_type = 'User'") }
  scope :not_recommended, -> { where(status: 0) }
  scope :recommended, -> { where(status: 1) }
  scope :accepted, -> { where(status: 2) }
  scope :user_created, ->(user_id) { videos.where('multimedia_id = ?', user_id) }
  scope :user_favorites, ->(user_id) { videos.includes(:favorites).where('favorites.user_id = ?', user_id) }
  scope :user_owns, ->(user_id) { videos.includes(:favorites).where('multimedia_id = ? OR favorites.user_id = ?', user_id, user_id) }

  paginates_per 10

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Video')
  end

  def root_object
    multimedia.try(:root_object)
  end

  def self.search(query)
    self.joins(:taggings).where('taggings.tag_id in (?) OR title ILIKE ?', Tag.where(name: query), "%#{query}%").uniq
  end

  def accepted?
    status == 2
  end

  def recommended?
    status == 1
  end

  def accept!
    self.status = 2
    save
  end

  def refuse!
    self.status = 0
    save
  end
end
