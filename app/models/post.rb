# encoding: utf-8
class Post < ActiveRecord::Base
  extend ModelExt::Paginates
  resourcify

  belongs_to :user, with_deleted: true
  belongs_to :journal, polymorphic: true, with_deleted: true
  belongs_to :category, class_name: 'CommunityPostCategory', foreign_key: 'category_id'

  has_one :illustration, class_name: 'PostIllustration', as: :imageable, dependent: :destroy
  has_many :images, class_name: 'PostImage', as: :imageable, dependent: :destroy, order: 'id asc'
  has_many :complaints, as: :pretension, dependent: :destroy
  has_many :favorites, as: :favoriteable
  has_many :videos, class_name: 'MediaContent', as: :multimedia, conditions: ['media_contents.video = ?', true], order: 'id asc'

  acts_as_taggable
  acts_as_votable
  acts_as_commentable
  DEPTH = 1

  attr_accessible :body, :title, :tag_list, :status, :category_id

  default_scope order("#{table_name}.created_at DESC")

  scope :not_recommended, -> { where(status: 0) }
  scope :recommended, -> { where(status: 1) }
  scope :accepted, -> { where(status: 2) }
  scope :community, -> { where(journal_type: 'Community') }
  scope :without_communities, -> { where('journal_type != \'Community\'') }
  scope :user_favorites, ->(user_id) { includes(:user, :favorites, :illustration).without_communities.where('favorites.user_id = ?', user_id).reorder('favorites.id DESC') }
  scope :user_created, ->(user_id) { includes(:user, :illustration).without_communities.where('journal_id = ?', user_id) }
  scope :user_owns, ->(user_id) { includes(:user, :favorites, :illustration).without_communities.where('journal_id = ? OR favorites.user_id = ?', user_id, user_id) }

  paginates_per 10

  def owner?(user)
    self.user_id == user.id
  end

  def root_object
    journal.try(:root_object)
  end

  def tags_string
    tags.map(&:text) * ','
  end

  def accepted?
    status == 2
  end

  def recommended?
    status == 1
  end

  def is_resource? *args
    if (self.new_record? ? self : self.reload).journal.is_a?(User)
      args.include? self.journal.profileable.class.name
    else
      args.include? self.journal.class.name
    end
  end

  def accept!
    self.status = 2
    save
  end

  def refuse!
    self.status = 0
    save
  end

  def self.search(query)
    self.joins(:taggings).where('taggings.tag_id in (?) OR title ILIKE ? OR body LIKE ?', Tag.where(name: query), "%#{query}%", "%#{query}%")
  end
end
