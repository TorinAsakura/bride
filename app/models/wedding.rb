# encoding: utf-8
class Wedding < ActiveRecord::Base
  # include Models::User::City
  include Models::Wedding::GenerateWedding

  has_many :clients, dependent: :nullify
  has_one  :groom, class_name: 'Client', conditions: ['gender = ?', true]
  has_one  :bride, class_name: 'Client', conditions: ['gender = ?', false]
  has_many :timetables, dependent: :destroy
  has_many :events, dependent: :destroy
  belongs_to :script

  mount_uploader :avatar, AvatarUploader

  attr_accessible :wedding_date, :role_ids, :avatar, :script_id, 
                  :color_ids, :start_date
  acts_as_taggable_on :colors

  validates :wedding_date, presence: true
  validates :script_id, presence: true, on: :create
  validate  :wedding_date_cannot_be_in_the_past
  validate  :check_colors_size

  after_create :create_wedding
  after_update :update_wedding

  def time_left
    (self.wedding_date - Date.today).to_i
  end

  def current_timetable
    cur_date = Date.today
    if self.wedding_date == cur_date
      ttb = self.timetables.wedding_day.first
    elsif self.wedding_date < cur_date
      ttb = self.timetables.after_wedding.first
    else
      ttb = self.timetables.where("(date_from <= ? and t_type = ?) or (t_type = ? and date_from = ?)",
                                  cur_date, Timetable::WEEK, Timetable::DAY, cur_date).order(:date_from).last
      if ttb.nil?
        ttb = self.timetables.planning.first
      end
    end
    ttb
  end

  def current_weddk_number
    (days_left / 7).to_i
  end

  def self.find_users_on_week(date1, date2, script_id)
    current_week = ((date1 - date2) / 7).to_i.abs
    wedding_ids = find_by_sql(['select weddings.id from weddings where cast((weddings.wedding_date - ?)/7 as integer) = ?  and script_id = ?',
                               date1, current_week, script_id]).collect(&:id)
    Client.find_all_by_wedding_id(wedding_ids)
  end

  def self.first_year
    Wedding.order(:wedding_date).select(:wedding_date).first.wedding_date.year
  end

  def self.last_year
    Wedding.order(:wedding_date).select(:wedding_date).last.wedding_date.year
  end

  private
  def wedding_date_cannot_be_in_the_past
    if !self.wedding_date.blank? and self.wedding_date < Date.today
      errors.add(:wedding_date, "Дата свадьбы не может быть прошедей")
    end
  end

  def check_colors_size
    errors.add(:colors, "too much colors(max 4)") if colors.size > 4
  end
end
