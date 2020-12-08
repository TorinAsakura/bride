# encoding: utf-8
class City < ActiveRecord::Base
  belongs_to :region
  has_many :clients

  has_many :city_firms
  has_many :firms, through: :city_firms
  has_many :t_firms #Temp Firms

  attr_accessible :name, :region_id, :latitude, :longitude, :wedding_city

  geocoded_by :full_name
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, :region, presence: true

  scope :enabled_for_firms, -> {where(wedding_city: true)}
  scope :without_cities,    ->(ids) {where('id not in (?)', ids)}
  scope :by_firm,           ->(firm) {enabled_for_firms.without_cities(firm.all_cities_ids)}
  scope :ordered,           -> { order(:name)}

  delegate :country, to: :region

  max_paginates_per 100
  paginates_per 20

  class << self
    def search_like_name(search_string, limit = 10)
      search_filtered = search_string.gsub(/[%?]/, '')
      City.where('lower(name) LIKE lower(?)', "%#{search_filtered}%" ).limit(limit)
    end

    def city_firms_for_filter
      c = self.includes(city_firms: :firm)
      c = c.joins 'LEFT JOIN city_firms ON city_firms.city_id = cities.id'
      c = c.joins 'LEFT JOIN firms ON firms.id = city_firms.firm_id'
      c = c.where('firms.id IS NOT NULL')
      c = c.uniq
    end

    def detect_by_ip(ip_str)
      ip = IPAddr.new(ip_str)
      City.joins("INNER JOIN ip_ranges ON cities.geoip_id = ip_ranges.city_id")
        .where("ip_ranges.range_start >= ? AND ip_ranges.range_end <= ?", ip.to_i, ip.to_i)
        .first
    end
  end

  def coordinates
    [latitude, longitude]
  end

  def text
    self.name
  end

  def country
    region.country
  end

  def full_name
    "#{name} (#{region.name})"
  end

  def name_index
    name.split('').first.upcase
  end

  def self.filtered_cities (search=nil)
    if search.blank?
      City.includes(:region)
    else
      ct = City.arel_table
      rt = Region.arel_table

      cities = City.includes(:region)
      cities = cities.where(rt[:name].matches("%#{search[:region]}%")) unless search[:region].blank?
      cities = cities.where(ct[:name].matches("%#{search[:city]}%")) unless search[:city].blank?
      cities = cities.where(ct[:wedding_city].eq(search[:wedding_city])) unless search[:wedding_city].blank?

      cities
    end
  end
end
