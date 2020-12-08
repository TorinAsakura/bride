class TaskPosition < ActiveRecord::Base

  attr_accessible :position

  belongs_to :task
  belongs_to :plan

  validates :position, presence: true
end
