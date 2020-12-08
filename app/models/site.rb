# encoding: utf-8
class Site < ActiveRecord::Base
  acts_as_votable
  paginates_per 15

  attr_accessible :code, :description, :name, :logo, :privacy, :client_id, :color, :remove_logo,
                  :header_image_id, :background_image_id, :header_picture, :background_picture, :remove_header_picture, :remove_background_picture

  belongs_to  :client
  has_many    :clients, dependent: :nullify # groom & bride
  has_one     :groom, class_name: 'Client', conditions: ['gender = ?', true]
  has_one     :bride, class_name: 'Client', conditions: ['gender = ?', false]
  has_many    :users,           through: :clients
  has_many    :idea_categories, through: :clients
  has_many    :idea_sections,   through: :idea_categories, source: :sections
  has_many    :ideas,           through: :clients
  has_many    :pages, dependent: :destroy
  has_many    :albums, as: :resource
  has_many    :photos, through: :albums

  has_many    :guestbooks, dependent: :destroy #TODO ???
  # services list
  has_many    :guests,       dependent: :destroy

  has_many    :seating_plans, class_name: 'Seating::Plan', dependent: :destroy
  has_one     :seating_plan,  class_name: 'Seating::Plan', conditions: {active: true}

  has_one     :wedding_calc, dependent: :destroy

  has_many    :wishlists,    dependent: :destroy
  has_many    :programms,    dependent: :destroy

  # Backgrounds
  belongs_to :header_image,     class_name: 'BackgroundProperty', counter_cache: true, inverse_of: :sites
  belongs_to :background_image, class_name: 'BackgroundProperty', counter_cache: true, inverse_of: :sites

  mount_uploader :logo, MiniSiteLogoUploader
  mount_uploader :header_picture,     MiniSiteHeaderUploader
  mount_uploader :background_picture, MiniSiteBackgroundUploader

  scope :displayed, -> { includes(client: :wedding).where('clients.wedding_id IS NOT NULL AND sites.logo IS NOT NULL')}

  delegate :user, :wedding, to: :client

  after_create   :link_clients
  after_create   :insert_system_pages
  before_destroy :unlink_clients
  after_create   :add_role
  before_validation  :parameterize_name

  validates :client, :name, presence: true
  validates :name, uniqueness: {unless: 'name.blank?'}
  validates :name, subdomain_format: {unless: 'name.blank?'}
  validate :unique_subdomain

  def can_edit?(user)
    return false unless user.site == self
    true
  end

  private
  def unique_subdomain
    if self.name_changed? && Firm.where(slug: self.name).present?
      self.errors.add(:name, 'Этот поддомен занят')
    end
  end

  def link_clients
    owner = self.client
    owner.site = self
    owner.save

    if owner.couple
      couple = owner.couple
      couple.site = self
      couple.save
    end
  end

  def unlink_clients
    self.clients.update_all(site_id: nil)
  end

  def insert_system_pages
    MINISITE_SYSTEM_PAGES.each do |page|
      @page = Page.new(page)
      @page.system = true
      self.pages << @page
      @page.save
    end
  end

  def parameterize_name
    self.name = self.name.try(:parameterize)
  end

  protected
  def add_role
    self.client.user.add_role(:moderator, self)
  end
end
