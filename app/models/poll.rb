# encoding: utf-8
class Poll < ActiveRecord::Base
  include Access

  attr_accessor :tmp_poll_images_ids
  attr_accessible :title, :images_attributes, :tmp_poll_images_ids
  validates :title, presence: true
  validates :images, length: { minimum: 2, maximum: 3 }, on: :create

  acts_as_votable
  acts_as_commentable
  DEPTH = 1

  belongs_to :client
  has_many :images, class_name: 'PollImage', as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :images

  default_scope order('created_at DESC')

  paginates_per 10

  def root_object
    self
  end

  def voted_images?(user)
    self.images.each {|img| return true if user.voted? img}
    false
  end

  def total_votes
    self.images.sum(:cached_votes_up)
  end

  def can_view_results?(user)
    user.present? && (self.voted_images?(user) || for_moderator_of(self.client, user))
  end
end
