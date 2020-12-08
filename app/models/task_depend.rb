# encoding: utf-8
class TaskDepend < ActiveRecord::Base
  belongs_to :parent, :class_name => 'Task', :foreign_key => 'parent_id'
  belongs_to :child, :class_name => 'Task', :foreign_key => 'task_id'

  attr_accessible :parent_id, :task_id
end

