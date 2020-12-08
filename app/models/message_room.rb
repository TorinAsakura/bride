# encoding: utf-8
class MessageRoom < ActiveRecord::Base
  scope :earned, lambda { includes(:messages).order("messages.created_at DESC") }
  attr_accessible :message_count
  has_and_belongs_to_many :users
  has_many :messages


  def unread_count
    self.messages.where(read: false).count
  end

  def recipient(exclude)
    self.users.where("id <> ?", exclude.id).first
  end

  def make_all_messages_in_room_as_read!
    self.messages.unread.each(&:read!)
  end

  alias :unread_messages_count :unread_count
end
