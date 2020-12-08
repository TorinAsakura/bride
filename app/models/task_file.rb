# encoding: utf-8
class TaskFile < ActiveRecord::Base
  mount_uploader  :url, TaskFileUploader
  attr_accessible :url, :title

  belongs_to :task
  validates :url, presence: true
end
