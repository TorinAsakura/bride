# encoding: utf-8
class Friendship < ActiveRecord::Base

  attr_accessible :friend_id, :status, :requested_at

  STATUS_ALREADY_FRIENDS = 1
  STATUS_ALREADY_REQUESTED = 2
  STATUS_IS_YOU = 3
  STATUS_FRIEND_IS_REQUIRED = 4
  STATUS_FRIENDSHIP_ACCEPTED = 5
  STATUS_REQUESTED = 6

  FRIENDSHIP_ACCEPTED = "accepted"
  FRIENDSHIP_PENDING = "pending"
  FRIENDSHIP_REQUESTED = "requested"

 # scopes
  scope :pending, :conditions => {:status => FRIENDSHIP_PENDING}
  scope :accepted, :conditions => {:status => FRIENDSHIP_ACCEPTED}
  scope :requested, :conditions => {:status => FRIENDSHIP_REQUESTED}

  # associations
  belongs_to :user
  belongs_to :friend, :class_name => 'User', :foreign_key => 'friend_id'

  # callback
  after_destroy do |f|
    User.decrement_counter(:friends_count, f.user_id) if f.status == FRIENDSHIP_ACCEPTED
  end

  #дружба была подтверждена?
  def accepted?
    self.status == FRIENDSHIP_ACCEPTED
  end

  #ожидает подтверждения
  def pending?
    self.status == FRIENDSHIP_PENDING
  end

  #
  def requested?
    self.status == FRIENDSHIP_REQUESTED
  end

  #подтвердить дружбу
  def accept!
    unless self.accepted?
      self.transaction do
        User.increment_counter(:friends_count, self.user_id)
        self.update_attribute(:status, FRIENDSHIP_ACCEPTED)
        self.update_attribute(:accepted_at, Time.now)
      end
    end
  end

end
