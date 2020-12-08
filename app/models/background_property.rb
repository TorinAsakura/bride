# encoding: utf-8
class BackgroundProperty < ActiveRecord::Base
  mount_uploader :image, BackgroundImageUploader

  attr_accessible :title, :color, :image, :attachment, :position, :repeat, :is_active,
                  :header, :sites_count, :general, :header_color, :header_date_color, :firms_count

  has_many :sites
  has_many :firms

  scope :popular_by_site, -> { order('sites_count desc') }
  scope :popular_by_firm, -> { order('firms_count desc') }
  scope :popular,         -> { popular_by_firm.popular_by_site }
  scope :ordered,         -> { order('updated_at desc') }
  scope :active,          -> { where(is_active: true) }
  scope :headers,         -> { where(header: true) }
  scope :backgrounds,     -> { where(header: false) }
  scope :mini_site,       -> { where(general: false) }
  scope :general,         -> { where(general: true) }

  alias_attribute :is_finished?, :is_active

  def self.main_background
    general.backgrounds.active.ordered.first
  end
end
