# encoding: utf-8
class Plan < ActiveRecord::Base
  belongs_to :script
  has_many :task_positions, dependent: :destroy
  has_and_belongs_to_many :tasks

  PLANNING  = :planning
  WEEK = :week
  DAY  = :day
  WEDDING_DAY = :wedding_day
  AFTER_WEDDING = :after_wedding

  attr_accessible :plan_type, :script_id, :task_ids, :index_number, :description
  symbolize :plan_type, in: [PLANNING, WEEK, DAY, WEDDING_DAY, AFTER_WEDDING], scopes: true, default: WEEK
end
