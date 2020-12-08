# encoding: utf-8
class Timetable < ActiveRecord::Base
  belongs_to :wedding
  belongs_to :plan

  has_many :events, dependent: :nullify
  has_many :firm_catalogs, through: :events, uniq: true, readonly: true
  has_many :firms, through: :firm_catalogs, uniq: true, readonly: true
  has_many :advanced_firms, through: :firm_catalogs, readonly: true
  has_many :usual_firms, through: :firm_catalogs, readonly: true

  attr_accessible :date_from, :t_type, :wedding_id, :index_number, :plan_id

  PLANNING = Plan::PLANNING
  WEEK = Plan::WEEK
  DAY  = Plan::DAY
  WEDDING_DAY = Plan::WEDDING_DAY
  AFTER_WEDDING = Plan::AFTER_WEDDING

  symbolize :t_type, in: [PLANNING, WEEK, DAY, WEDDING_DAY, AFTER_WEDDING], scopes: true, default: WEEK

  validates :t_type, :wedding_id, :index_number, presence: true
  validates :date_from, presence: true, unless: 'date_from.nil?'
  validate  :check_date_from

  def name
    case self.t_type
       when WEEK then ''
       when DAY then ''
       when WEDDING_DAY then 'День свадьбы'
       when AFTER_WEDDING then 'После свадьбы'
       else 'Подготовка'
    end
  end

  def prev
    self.wedding.timetables.find_by_id(id + 1)
  end

  def next
    self.wedding.timetables.find_by_id(id - 1)
  end

  def to_end
    case self.t_type
    when :planning then 'Планирование'
    when :week, :planning then "#{index_number} недель"
    when :day then "#{wedding.timetables.day.collect {|d| d if d.id < id}.compact.count + 1} дней"
    when :wedding_day then 'День свадьбы'
    end
  end

  def info_format
    case t_type
    when :wedding_day then 'День свадьбы'
    when :day then "#{index_number} дней до свадбы"
    when :week then "#{index_number} недель до свадьбы"
    when :planning then 'Планирование'
    when :after_wedding then 'После свадьбы'
    else 'error'
    end
  end

  def last_event_id
    self.events.unhidden.any? ? self.events.unhidden.includes(task: :task_positions).order_by_position.first.id : 0
  end

  private
  def check_second_week
    #Днем может быть только первая неделя(разбитая по дням/неделя перед свадьбой)
    errors.add(:index_number, 'Не правильный index_number для t_type') if self.t_type == DAY && self.index_number != 1
  end

  def check_date_from
    #Дата начала недели, не может быть больше даты свадьбы
    errors.add(:date_from, 'Не верная дата начала недели') if !self.date_from.nil? && self.date_from > self.wedding.wedding_date
  end
end
