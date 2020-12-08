# encoding: utf-8
class FirmCatalog < ActiveRecord::Base
  include TheSortableTree::Scopes
  acts_as_nested_set counter_cache: :children_count
  extend FriendlyId
  friendly_id :name, use: :slugged

  mount_uploader :logo, FirmCatalogLogoUploader

  attr_accessible :name, :parent_id, :logo, :children_count, :extended_name, :category
  attr_accessor :logo_x, :logo_y, :logo_x2, :logo_y2, :logo_scale

  has_many :spheres
  has_many :firms, through: :spheres
  has_many :t_firms #Temp Firms

  has_and_belongs_to_many :advanced_firms, class_name: "Firm", conditions: { firms: { status: Firm::ADVANCED } }
  has_and_belongs_to_many :usual_firms,    class_name: "Firm", conditions: { firms: { status: Firm::USUAL } }

  has_many :firm_catalog_tasks, dependent: :destroy
  has_many :tasks, through: :firm_catalog_tasks
  has_many :idea_category_tasks, through: :tasks
  has_many :bonus_prices, class_name: 'Bonus::Price'

  validates :name, presence: true

  scope :bottom,                -> { where("parent_id IS NOT NULL") }
  scope :top,                   -> { roots }
  scope :not_empty,             -> { includes(:spheres).joins('LEFT JOIN spheres ON spheres.firm_catalog_id = firm_catalogs.id').where('spheres.firm_id IS NOT NULL').uniq }
  scope :without_firm_catalogs, ->(ids) {where('id not in (?)', ids)}
  scope :by_firm,               ->(firm) {(ids = firm.all_firm_catalog_ids).blank? ? top : top.select{|fc| !fc.firm_catalogs.without_firm_catalogs(ids).count.zero?}}
  scope :ordered,               -> { order(:name) }

  before_destroy :check_children
  after_create :add_base_bonus_price

  class << self
    def catalog_with_firms
      catalog = self.includes(:spheres)
      catalog = catalog.joins 'LEFT JOIN firm_catalogs firm_catalogs_firm_catalogs ON firm_catalogs_firm_catalogs.parent_id = firm_catalogs.id'
      catalog = catalog.joins 'LEFT JOIN spheres ON spheres.firm_catalog_id = firm_catalogs_firm_catalogs.id'
      catalog = catalog.where 'spheres.firm_id IS NOT NULL'
      catalog = catalog.roots.uniq
    end
  end

  def children
    root? ? super : firms
  end

  def firm_catalogs
    children
  end

  def jcrop_resize?
    logo_x && logo_y && logo_x2 && logo_y2 && logo_scale
  end

  private
  def check_children
    if self.children.present?
      errors.add(:base, "Can't be destroyed, because of children presence.")
      return false
    end
  end

  def add_base_bonus_price
    pro = Bonus::Service::Pro.first
    pro.prices.firm_catalog(self).update_attribute(:amount, pro.amount)
  end
end

