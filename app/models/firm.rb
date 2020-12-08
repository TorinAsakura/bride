# encoding: utf-8
class Firm < ActiveRecord::Base
  include BonusServiceConcern

  extend FriendlyId
  friendly_id :id, use: :slugged

  paginates_per 15

  USUAL    = 'usual'
  AVERAGE  = 'average'
  ADVANCED = 'advanced'

  DEPTH = 2

  mount_uploader :logo,               FirmLogoUploader
  mount_uploader :background_picture, MiniSiteBackgroundUploader

  attr_accessible :country, :logo, :phone, :firm_catalog_ids, :base_sphere_id,
    :description, :status, :contact_name, :skype, :website, :city_ids,
    :administrator, :moderator_ids, :business, :business_type, :slug,
    :text_status, :user_id, :not_ready, :name, :firm_catalogs_attributes,
    :spheres_attributes, :user_attributes, :extended_name, :city_firms_attributes,
    :base_sphere_attributes, :logo_x, :logo_y, :logo_x2, :logo_y2, :logo_scale,
    :business_card_left_block, :business_card_right_block, :firm_services_attributes,
    :parent_token, :parent_id, :dealer, :background_image, :background_picture

  attr_accessible :balance, :ready, as: :admin

  attr_accessor :logo_x, :logo_y, :logo_x2, :logo_y2, :logo_scale, :not_ready,
                :parent_token

  has_one :user, as: :profileable, dependent: :destroy
  has_many :roles, through: :user

  has_many :spheres
  has_one :sphere, conditions: { base: true }
  has_many :firm_catalogs, through: :spheres

  has_many :city_firms, order: 'rating'
  has_many :cities, through: :city_firms, order: 'rating'
  has_many :addresses, through: :city_firms, order: 'rating'
  has_one  :base_city_firm, class_name: 'CityFirm', conditions: {rating: 1}
  has_one  :base_city, through: :base_city_firm, source: :city

  has_many :timetables, through: :events
  has_many :weddings, through: :timetables
  has_many :clients, through: :weddings
  has_many :firm_services
  has_one  :card_service, class_name: 'FirmService', conditions: 'raiting < 0'

  has_many :competitions
  has_many :complaints, as: :pretension
  has_many :firm_pages

  belongs_to :background_image, class_name: 'BackgroundProperty', counter_cache: true, inverse_of: :firms

  has_and_belongs_to_many :events

  #belongs_to :user # administrator
  belongs_to :base_sphere, class_name: 'FirmCatalog'
  belongs_to :banner_album, class_name: 'Album'
  belongs_to :wedding_city, class_name: 'City'
  belongs_to :business, polymorphic: true # форма собственности

  # Dealer
  belongs_to :dealer, class_name: 'Firm', foreign_key: :parent_id
  has_many :children_firms, class_name: 'Firm', foreign_key: :parent_id

  # Payments
  # Перевод в систему
  has_many :purse_payment_transfer_to_systems,           class_name: 'PursePayment::TransferToSystem',           as: :target #От игрока
  has_many :purse_payment_system_transfer_from_firms,    class_name: 'PursePayment::SystemTransferFromFirm',     as: :target #В Систему


  accepts_nested_attributes_for :firm_catalogs
  accepts_nested_attributes_for :base_sphere
  accepts_nested_attributes_for :spheres, allow_destroy: true
  accepts_nested_attributes_for :city_firms, allow_destroy: true
  accepts_nested_attributes_for :firm_services, allow_destroy: true
  accepts_nested_attributes_for :user

  delegate :name, to: :base_sphere, prefix: true
  delegate :friends, :comment_threads, :albums, :posts, :videos, :email, :dealer?, :purse, to: :user

  acts_as_votable
  acts_as_paranoid

  # order
  #default_scope joins(:user).where(:ready => true).order("#{table_name}.name")
  #default_scope where(:ready => true).order("#{table_name}.name")

  # Polymorphic scopes
  scope :ies,         -> { where(business_type: 'Ie') } # Ie = individual entrepreneur (индивидуальный предприниматель)
  scope :pps,         -> { where(business_type: 'Pp') } # Pp = Private Person (Частное лицо)
  scope :companies,   -> { where(business_type: 'Company') } # Company = одна из возможных форм собственности (ООО, ЗАО, ОАО ...)
  scope :subscribers, -> { includes(:user).where(users: {subscription: true}) }
  scope :dealers,     -> { includes(:roles).where(roles: {name: 'dealer'})}
  scope :by_city,     ->(city) {includes(:cities).where(cities: {id: city.id})}
  scope :ordered,     -> { order('firms.name asc')}
  scope :catalog_ordered, -> { includes(:user).order('firms.bonus_status desc, firms.bonus_high_in_at desc, users.last_sign_in_at')}

  symbolize :status, in: [USUAL, AVERAGE, ADVANCED], scopes: true, default: USUAL

  validates :name, presence: true

  # we will create firm after user registration with skiping of firm_catalog:
  #validates :spheres, :description, :presence => true, :if => "not_ready.nil?"

  validate :check_status, on: :update
  validate :unique_subdomain, on: :update
  #validate :at_least_one_city_firm, :on => :update

  validates :slug, presence: true, on: :update
  validates :slug, slug_format: { unless: 'slug.blank?' }
  validates :slug, uniqueness: { unless: 'slug.blank?' }

  before_create :generate_token
  before_save :touch_bonus_status
  after_create :update_dealers
  after_create :generate_slug
  after_create :create_banner_album
  after_create :create_pages
  after_create :create_card_service
  after_validation :parameterize_slug

  class << self
    def search conditional, catalogs
      Firm.all.delete_if{ |f| f.firm_services.blank? }.group_by(&:status)
    end

    def get_emails
      Firm.subscribers.select('users.email').map(&:email)
    end

    def filtered(search=nil)
      firms = self.includes(:user)
      if search.present?
        ct = City.arel_table
        ft = self.arel_table
        firms = firms.where(ct[:name].matches("%#{search[:city]}%")) if search[:city].present?
        firms = firms.where(ft[:name].matches("%#{search[:name]}%")) if search[:name].present?
      end
      firms
    end
  end

  def has_children_firms?
    children_firms.any?
  end

  def has_spheres?
    spheres.any?
  end

  def has_cities?
    city_firms.any?
  end

  def administrator
    if self.user
      self.user.login
    else
      ''
    end
  end

  def administrator= login
    self.user = User.find_by_login(login)
  end

  def full_name
    self.name
  end

  def min_price
    firm_services.reorder('cost').first
  end

  def cities_names
    cities.map { |c| c.name }.join(", ")
  end

  def site
    city_firms.first.base_address.try(:site)
  end

  def base_city_id
    base_city.try(:id)
  end

  # for USUAL firm
  def firm_catalog
    (first = spheres.first) ? first.firm_catalog.parent : nil
  end

  def all_spheres
    spheres.with_deleted
  end

  def all_firm_catalogs
    FirmCatalog.where("id IN (?)", all_firm_catalog_ids)
  end

  def all_firm_catalog_ids
    all_spheres.select(:firm_catalog_id).map(&:firm_catalog_id)
  end

  def all_city_firms
    city_firms.with_deleted
  end

  def all_cities
    City.where("id IN (?)", all_cities_ids)
  end

  def all_cities_ids
    all_city_firms.select(:city_id).map(&:city_id)
  end

  def telephone
    city_firms.first.try(:base_address).try(:phone)
  end

  def address
    (base_address = city_firms.first.try(:base_address)).present? ? base_address.decorate.full_address : ''
  end

  def change_status new_status
    self.status = new_status
    self.save(validate: false)
  end

  def generate_slug
    slug_candidate = DateTime.now.strftime '%y%-j%-H%-M%-S%-L'
    until Firm.where('firms.slug = ?', slug_candidate).empty?
      slug_candidate = DateTime.now.strftime '%y%-j%-H%-M%-S%-L'
    end
    self.update_attribute(:slug, slug_candidate)
  end

  def create_pages
    names = ['journal', 'albums', 'videos', 'comments', 'addresses', 'firm-services']
    names.each { |n| firm_pages.create(name: n) }
  end

  def create_card_service
    card_service = firm_services.new(raiting: -1)
    card_service.save(validate: false)
  end

  def business_card_left
    business_card_block(business_card_left_block)
  end

  def business_card_right
    business_card_block(business_card_right_block)
  end

  def update_logo
    if logo
      logo.recreate_versions!
      save!
    end
  end

  ['videos', 'albums', 'journal', 'addresses'].each do |page|
    define_method "show_#{page}?" do
      firm_pages.where(name: page).first.shown
    end
  end

  def set_default_city! detected_city
    return if self.cities.any?

    unless detected_city.enabled_for_firms?
      self.cities << City.enabled_for_firms.near(detected_city, 100).first
    end
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  def jcrop_resize?
    logo_x && logo_y && logo_x2 && logo_y2 && logo_scale
  end

  def show_services?
    firm_pages.where(name: 'firm-services').first.shown
  end

  def public_by?(user)
    self.has_active_pro? || user.present? && (user.admin? || self.owner?(user) || ((dealer = self.dealer).present? && dealer.user.is?(user) ))
  end

  def owner? user
    #(self.user_id == user.id || (self.moderator_ids.include? user.id))
    self.user == user
  end

  def can_edit? user 
    # todo: check for cancan gem?
    #return false unless (self.user_id == user.id || (self.moderator_ids.include? user.id))
    self.user == user
    #true
  end

  def cutaway_colored?
    (color_at = self.bonus_color_at).present? && color_at.future?
  end

  private
  def touch_bonus_status
    status = if (vip_at = self.bonus_vip_at).present? && vip_at.future?
               self.cutaway_colored? ? 4 : 3
             elsif (pro_at = self.bonus_pro_at).present? && pro_at.future?
               self.cutaway_colored? ? 2 : 1
             else
               0
             end
    self.bonus_status = status

    self.bonus_high_in_at = nil if self.bonus_high_in_at.present? && self.bonus_high_in_at.past?
  end

  def generate_token
    begin
      token = Digest::SHA1.hexdigest([Time.now.to_i, (1..10).map{ rand.to_s }].flatten.join('--'))
    end while self.class.find_all_by_invite_token(token).nil?
    self.invite_token = token if self.invite_token.blank?
  end

  def update_dealers
    dealer= (token = self.parent_token).present? && Firm.find_by_invite_token(token)
    dealer ||= dealer.blank? && (city = self.base_city).present? && Firm.dealers.by_city(city).first

    if dealer
      self.dealer = dealer
      self.save
      if (city_firm = self.city_firms.by_city(dealer.base_city).first).present?
        city_firm.dealer = dealer
        city_firm.save
      end
    end
  end

  def unique_subdomain
    if self.slug_changed? && (Firm.where(slug: self.slug).present? || Site.where(name: self.slug).present?)
      self.errors.add(:status, 'Этот поддомен занят')
    end
  end

  def check_status
    if self.status_changed? && self.status == :advanced && self.status_change[0].to_s != self.status_change[1].to_s
      # todo:
      # 1. redo condition with self.status_change[0]
      # 2. move 1000 to another place. Constants?
      if self.balance < 1000
        self.errors.add(:status, 'Недостаточно средств на балансе')
      else
        self.balance -= 1000
      end
    end
  end

  def at_least_one_city_firm
    errors.add(:city_firms_attributes, 'Фирма должна принадлежать как минимум к одному городу.') if
      city_firms.size < 1 || city_firms.all?{|cf| cf.marked_for_destruction? }
  end

  def create_banner_album
    self.banner_album ||= Album.create(name: 'Баннеры', system: 1)
    self.save
  end

  def root_object
    self
  end

  def parameterize_slug
    self.slug = self.slug.parameterize
  end

  def business_card_block(block)
    case block
      when 1 then :videos
      when 2 then :albums
      when 3 then :journal
      when 4 then :services
      else :nothing
    end
  end

  #search methods
  def self.named_like name
    name ? where('firms.name like ?', "%#{name}%") : scoped
  end

  def self.in_catalogs ids
    ids ? joins(spheres: :firm_catalog).where('firm_catalogs.id in (?)',ids) : scoped
  end

  # FirmCatalog.joins(:spheres).where("spheres.firm_id IN ?", ids)

  def self.in_cities ids
    ids ? joins(:cities).where('cities.id in (?)',ids) : scoped
  end

  def self.section_firms(catalog, city, search)
    if catalog
      fc_table = FirmCatalog.arel_table
      f_table = self.arel_table

      catalog_ids = [catalog.id]

      firm_catalog_ids = FirmCatalog.unscoped.find(catalog.id).firm_catalogs
      unless firm_catalog_ids.blank?
        firm_catalog_ids = firm_catalog_ids.pluck(:id)
        catalog_ids = catalog_ids + firm_catalog_ids
      end

      firms = self.includes spheres: :firm_catalog

      firms = firms.where(fc_table[:id].eq(catalog.id).or(
                              f_table[:base_sphere_id].eq_any(catalog_ids).or(
                                  fc_table[:parent_id].eq(catalog.id)
                              )
                          ))
    else
      firms = self.joins spheres: :firm_catalog
    end

    firms = firms.includes(city_firms: :city).where(city_firms: { city_id: city.id}) if city.present?

    firms = firms.named_like search if search.present?

    firms = firms.catalog_ordered
    firms.uniq
  end

  def self.options_for_business_card
    [['Ничего', 0],
     ['Последняя Видеозапись', 1],
     ['Последние Фотографии', 2],
     ['Последняя запись в Журнале', 3],
     ['Блок Услуги', 4]]
  end
end
