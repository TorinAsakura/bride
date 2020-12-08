# encoding: utf-8
class Client < ActiveRecord::Base
  resourcify
  acts_as_paranoid

  include Models::User::City

  attr_accessible :avatar, :couple_id, :birthday, :wedding_id, :gender, :type_user,
                  :city_id, :text_status, :firstname, :lastname, :user_attributes,
                  :description, :vk, :fb, :tw, :mailru, :remote_avatar_url,
                  :activities, :interests, :favorite_music, :favorite_films, :favorite_shows,
                  :favorite_books, :favorite_games, :favorite_quotes, :about, :visibility,
                  :country_id, :children, :alcohol_attitude, :smoking_attitude,
                  :avatar_x, :avatar_y, :avatar_x2, :avatar_y2, :avatar_scale, :thing_in_life, :thing_in_humans,
                  :marital_status, :visited_at, :avatar_image

  has_one :user, as: :profileable, dependent: :destroy
  has_one :avatar_image, class_name: 'Avatar'
  has_one :couple, class_name: 'Client'
  has_one :wedding_invite

  has_many :polls
  has_many :promises
  has_many :user_ideas, through: :user
  has_many :ideas, through: :user_ideas
  has_many :idea_categories, through: :user_ideas, source: :category
  has_many :idea_sections, through: :idea_categories, source: :sections
  has_many :invited, class_name: 'WeddingInvite', foreign_key: 'couple_id'

  belongs_to :site
  belongs_to :wedding
  belongs_to :couple, class_name: 'Client'
  belongs_to :wedding_city, class_name: 'City'
  belongs_to :country
  belongs_to :city

  has_and_belongs_to_many :communities

  accepts_nested_attributes_for :user
  delegate :friends, :comment_threads, :albums, :posts, :videos, :email, :subscription, to: :user

  scope :no_couple,   -> { where('couple_id IS NULL OR couple_id = 0') }
  scope :subscribers, -> { includes(:user).where(users: {subscription: true})}
  scope :confirmed,   -> { includes(:user).where('users.confirmed_at IS NOT NULL')}
  scope :displayed,   -> { includes(:user).confirmed.where('clients.firstname IS NOT NULL')}

  attr_accessor :avatar_x, :avatar_y, :avatar_x2, :avatar_y2, :avatar_scale
  mount_uploader :avatar, AvatarUploader
  acts_as_votable

  DEPTH = 2

  paginates_per 15

  before_create :build_avatar_image
  before_create :add_default_wedding_city
  after_create :add_role_to_user

  def neighbors(limit = 10)
    Client.where("city_id = ? and id <> ?", self.city_id, self.id).limit(limit)
  end

  def make_wedding(couple_obj = nil)
    self.update_attributes({couple_id: couple_obj.id})
  end

  def add_to_wedding(wedding)
    self.update_attributes({wedding_id: wedding.id}) #if !self.new_record?
  end

  def full_name
    if user.blank? || user.destroyed?
      'Пользователь'
    else
      [firstname, lastname].map(&:presence).compact.join(' ')
    end
  end

  def city_name
    self.city.try(:name)
  end

  def my_wedding
    self.wedding
  end

  def create_invite couple
    wi = WeddingInvite.new
    wi.couple = couple
    wi.client = self
    wi.save
  end

  def root_object
    self
  end

  def invited_couple
    Client.find(self.couple_id)
  end

  def age
    now = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

  def couple_or_invite
    invite_couple = self.wedding_invite.present? ? self.wedding_invite.couple : nil
    self.couple || invite_couple
  end

  def invite_couple firstname, lastname, email
    resource = Client.new(firstname: firstname, lastname: lastname, gender: !self.gender)
    resource.couple = self
    resource.save
    User.invite!({ email: email,
                   login: email,
                   profileable_type: 'Client',
                   profileable_id: resource.id,
                   read: true }, self.user).save
    resource
  end

  def create_couple_with client
    self.couple = client
    self.save
    client.couple  = self
    client.wedding = self.wedding
    client.site = self.site
    client.wedding_city = self.wedding_city
    client.save
  end

  def break_couple
    self.couple  = nil
    self.wedding = nil
    self.site = nil
    self.save
  end

  def destroy_wedding
    self.wedding.events.destroy_all
    self.wedding.timetables.destroy_all
    self.wedding.destroy
  end

  def copy_wedding resource
    ActiveRecord::Base.transaction do
      Wedding.skip_callback(:create, :after, :create_wedding)
      wedding_dup = Wedding.create(resource.attributes)
       Wedding.set_callback(:create, :after, :create_wedding)
      self.wedding = wedding_dup
      self.save

      resource.timetables.each do |tt|
        tt_dup = wedding_dup.timetables.create(tt.attributes)
        tt.events.each do |e|
          e_dup = tt_dup.events.new(e.attributes.except('id', 'created_at', 'updated_at'))
          e_dup.wedding = wedding_dup
          e_dup.save
        end
      end
      resource.events.without_timetable.each do |eh|
        wedding_dup.events.create(eh.attributes)
      end
    end #ActiveRecord::Base.transaction
  end

  def update_avatar
    if avatar
      avatar.cache_stored_file!
      avatar.retrieve_from_cache!(avatar.cache_name)
      avatar.recreate_versions! :usual
      save!
    end
  end

  def zodiac
    case self.birthday.strftime('%m%d').to_i
      when 121..219   then 'Водолей'
      when 220..320   then 'Рыбы'
      when 321..420   then 'Овен'
      when 421..521   then 'Телец'
      when 522..621   then 'Близнецы'
      when 622..722   then 'Рак'
      when 723..822   then 'Лев'
      when 823..923   then 'Дева'
      when 924..1023  then 'Весы'
      when 1024..1122 then 'Скорпион'
      when 1123..1222 then 'Стрелец'
      when 1223..1231 then 'Козерог'
      when 11..120    then 'Козерог'
      else 'error'
    end
  end

  def set_default_city!(detected_city)
    return unless self.city.blank?
    update_attribute(:city, detected_city)
  end

  def is? client
    self.id == client.id
  end

  def male?
    self.gender
  end

  def female?
    !self.gender
  end

  def jcrop_resize?
    avatar_x && avatar_y && avatar_x2 && avatar_y2 && avatar_scale
  end

  def has_couple?
    self.couple.present?
  end

  def not_couple?
    !self.has_couple?
  end

  def has_site?
    self.site.present?
  end

  def has_wedding?
    self.wedding.present?
  end

  def betrothed_to? couple
    self.couple == couple
  end

  def invited? couple
    self.wedding_invite.present? && self.wedding_invite.couple == couple 
  end

  def not_invited? couple
    !self.invited? couple
  end

  def has_couple_or_invite?
    self.has_couple? || self.wedding_invite.present?
  end
  def self.search_like_login(search_string, limit = 10)
    users = User.arel_table
    User.where(users[:login].matches("%#{search_string.gsub(/[%?]/, '')}%")).limit(limit)
  end

  def self.search
    cur_date = Date.today
    self.includes(wedding: :timetables).
           where("(timetables.date_from <= ? and timetables.type = ?) or
           (timetables.ttype = ? and timetables.date_from = ?)",
           cur_date, Timetable::WEEK, Timetable::DAY, cur_date)
  end

  def self.on_current_timetable timetable
    cur_date = Date.today
    self.includes(:user).find_by_sql(['SELECT  DISTINCT "clients".* FROM "clients" LEFT OUTER JOIN "weddings" ON
          "weddings"."id" = "clients"."wedding_id" LEFT OUTER JOIN "timetables" ON
          "timetables"."wedding_id" = "weddings"."id" LEFT OUTER JOIN "users" ON
          "users"."profileable_id" = "clients"."id" AND "users"."profileable_type" = \'Client\'
          WHERE clients.wedding_id is not null AND timetables.t_type = ? AND timetables.index_number = ?  AND
          timetables.date_from >= ? AND timetables.date_from <= ? LIMIT ?',
          timetable.t_type, timetable.index_number, cur_date - 5, cur_date + 5, CLIENTS_ON_CURRENT_WEEK])
  end

  def self.get_emails gender_params
    gender = []
    gender << true if gender_params[:male].eql?('true')
    gender << false if gender_params[:female].eql?('true')
    gender << nil if gender_params[:without].eql?('true')
    Client.subscribers.where(gender: gender).includes(:user).select('users.email').map(&:email)
  end

  private
  def add_role_to_user
    self.user.add_role(:moderator, self) if self.user.present?
  end

  def add_default_wedding_city
    #TODO возможно потом надо будет переделать на определение города по GEO
    self.wedding_city = City.find_by_name('Москва')
  end
end
