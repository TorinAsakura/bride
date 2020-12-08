# encoding: utf-8
class TaskCategory < ActiveRecord::Base
  default_scope order('name')
  attr_accessible :name
  has_many :tasks
  has_many :events, foreign_key: 'task_id'
  #after_create :create_blank_task

  validates :name, presence: true

  private
    def create_blank_task
      Task.create(name: 'Новая Задача', task_category_id: self.id)
    end
end
