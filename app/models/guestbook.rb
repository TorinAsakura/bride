# encoding: utf-8
class Guestbook < ActiveRecord::Base
  default_scope where('guestbooks.user_id is not ?', nil).order('guestbooks.created_at ASC')
  attr_accessible :content, :name

  belongs_to :site
  belongs_to :user

  validates :content, presence: true
end
