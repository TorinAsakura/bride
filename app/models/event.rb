# encoding: utf-8
class Event < ActiveRecord::Base
  include TaskModule
  include AASM

  acts_as_taggable

  belongs_to :task
  belongs_to :wedding
  belongs_to :timetable
  has_and_belongs_to_many :firms

  attr_accessible :date_to, :description, :name, :task_id, :timetable_id, :wedding_id,
                  :firm_id,  :firm_ids, :custom_firm, :aasm_state, :tag_list

  aasm do
    state :uncompleted, initial: true
    state :hidden
    state :completed

    event :complete do
      transitions from: :uncompleted, to: :completed
    end
    event :uncomplete do
      transitions from: [:completed, :hidden], to: :uncompleted
    end
    event :hide do
      transitions from: [:completed, :uncompleted], to: :hidden
    end
  end

  delegate :image, to: :task, allow_nil: true
  validates :date_to, presence: true

  scope :overdue, ->(date) { uncompleted.where("date_to < ? and date_to < ? and type_task <> 'advice' and timetable_id IS NOT NULL", date, Date.today) } #просроченные
  scope :now, -> { where("date_to = ?", Date.today) } # задания на текущий день
  scope :user_event, -> { where(task_id: nil).reorder(:created_at) }
  scope :sys_event, -> { where('task_id IS NOT NULL') }
  scope :order_by_position, -> { includes(task: :task_positions).order('task_positions.position, task_positions.plan_id')}
  scope :service, conditions: { type_task: WITH_SERVICE } #задачи с сервисом
  scope :simply,  conditions: { type_task: SIMPLY } #простая задача
  scope :advice,  conditions: { type_task: ADVICE } #задача - совет
  scope :change,  conditions: { type_task: [SIMPLY, WITH_SERVICE] }
  scope :without_timetable, -> { where(timetable_id: nil) }
  scope :unhidden, -> { where("aasm_state <> 'hidden'") }
  
  scope :group_blogs, conditions: { type_task: 'with_service' }

  def user_event?
    self.task_id == nil
  end

  def system_event?
    !user_event?
  end

  def have_firms?
    self.system_event? && (self.task.firms.any? || self.task.t_firms.any?)
  end

  def get_paginate page, count
    task.present? ? task.ideas.includes(:image).page(page).per(count) : nil
  end

  def change_subevent_checkbox subevent_id, status
    old_status = status == '1' ? '' : ' checked'
    new_status = status == '1' ? ' checked' : ''
    reg_exp = /\<input .{15,20} value=\"#{subevent_id}\" class\=\"sv-event__input-checkbox\" type\=\"checkbox\"#{old_status}\>/
    checkbox_html = "<input name=\"checked#{subevent_id}\" value=\"#{subevent_id}\" class=\"sv-event__input-checkbox\" type=\"checkbox\"#{new_status}>"
    self.description = self.description.sub(reg_exp,checkbox_html)
    self.save 
  end
end
