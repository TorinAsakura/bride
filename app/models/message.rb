# encoding: utf-8
class Message < ActiveRecord::Base
  default_scope order('created_at DESC')
  scope :unread, -> { where(read: false) }

  attr_accessible :user_id, :recipient_id, :subject, :body, :message_room_id, :images_attributes

  belongs_to :user, with_deleted: true
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id', with_deleted: true
  belongs_to :message_room

  validates :body, :user_id, :recipient_id, :message_room_id, presence: true
  validate :can_not_send_myself

  has_many :images, class_name: 'MessageImage',  as: :imageable, dependent: :destroy
  has_many :videos, class_name: 'MediaContent', as: :multimedia
  accepts_nested_attributes_for :images

  def read!
    self.update_attribute(:read, true)
  end

  def read?
    self.read
  end

  def reply
    Message.new(message_room_id: self.message_room_id, user_id: self.recipient_id, recipient_id: self.user_id, subject: self.subject_reply)
  end

  def self_reply
    Message.new(message_room_id: self.message_room_id, user_id: self.user_id, recipient_id: self.recipient_id, subject: self.subject_reply)
  end

  def subject_reply
    'Re: ' + self.subject.to_s
  end

  private
  def can_not_send_myself
    if self.user_id == self.recipient_id
      errors.add(:recipient_id, 'can_not_send_myself')
    end
  end

  def check_message_room
    Message.where()
  end
end
