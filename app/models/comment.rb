# encoding: utf-8
class Comment < ActiveRecord::Base
  include Access

  paginates_per 3
  DEPTH = 2
  acts_as_nested_set scope: [:commentable_id, :commentable_type]
  acts_as_votable
  acts_as_paranoid

  has_many :complaints, as: :pretension
  has_many :images, class_name: 'UserCommentImage', as: :imageable,  dependent: :destroy
  has_many :videos, class_name: 'MediaContent',     as: :multimedia, dependent: :destroy

  attr_accessor :pictures, :videos_attributes
  attr_accessible :pictures, :body

  belongs_to :commentable, polymorphic: true, with_deleted: true
  belongs_to :user,                           with_deleted: true

  after_create :update_last_comment_at

  def self.build_from(commentable, user_id, parent_id)
    comment = self.new
    comment.commentable_id = commentable.id
    comment.commentable_type = commentable.class.base_class.name
    comment.parent_id = parent_id
    comment.user_id = user_id
    comment
  end

  def has_children?
    self.children.size > 0
  end

  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end

  def can_moderate?(user)
    self.user && self.user.owner?(user) || for_moderator_of(self.root_object, user)
  end

  def can_comment?
    self.level < self.class::DEPTH - 1
  end

  def root_object
    commentable.try(:root_object)
  end

  private
  def update_last_comment_at
    self.commentable.touch(:last_comment_at) if self.commentable_type == 'Post'
  end
end
