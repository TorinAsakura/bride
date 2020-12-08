# encoding: utf-8
class Script < ActiveRecord::Base
  has_many :plans, dependent: :destroy
  has_many :tasks, through: :plans
  has_many :weddings
  attr_accessible :description, :name, :weeks

  validates :weeks, presence: true, numericality: { only_integer: true }

  after_create :create_blank_plan, unless:  Proc.new { |f| self.weeks.nil? }

  def self.select_script wedding_date, start_date
    weeks = (( wedding_date - start_date ).to_i) / 7 #calc weeks
    find_by_weeks(weeks) || order(:weeks).last
  end

  private
    def create_blank_plan
      weeks = self.weeks.to_i - 1
      days, wedding_day = 7, 0
      Plan.create(script_id: self.id, plan_type: Plan::AFTER_WEDDING, index_number: wedding_day - 1)
      Plan.create(script_id: self.id, plan_type: Plan::WEDDING_DAY, index_number: wedding_day)
      days.times { |i| Plan.create(script_id: self.id, plan_type: Plan::DAY, index_number: i + 1) }
      weeks.times { |i| Plan.create(script_id: self.id, plan_type: Plan::WEEK, index_number: i + 2) }
      Plan.create(script_id: self.id, plan_type: Plan::PLANNING, index_number: Plan.last.index_number + 1)
    end
end
