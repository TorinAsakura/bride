# encoding: utf-8
class CityFirm < ActiveRecord::Base
  acts_as_paranoid
  MARKER_COLORS = ['red', 'green', 'blue', 'orange', 'pink', 'firebrick', 'forestgreen', 'magenta']

  attr_accessible :city_id, :firm_id, :base, :address_ids, :addresses_attributes, :rating, :dealer, :dealer_id
  validates :city_id, :firm_id, presence: true
  validates :city_id, uniqueness: {scope: :firm_id}

  belongs_to :city
  belongs_to :firm
  belongs_to :dealer, class_name: 'Firm'
  has_many :addresses
  has_one :base_address, class_name: "Address", order: 'position'

  accepts_nested_attributes_for :addresses, allow_destroy: true

  before_create :add_details

  scope :by_city, ->(city) { where(city_firms: {city_id: city.try(:id)})}

  def addresses_for_map
    all_addresses.each_with_index.map do |a, i|
      {
        address: a.coordinates ? a.location : a.address,
        name: a.name,
        explanation: a.explanation.presence || a.address,
        color: MARKER_COLORS[i % MARKER_COLORS.length],
        id: "#{id}_#{a.id}",
        phone: a.all_phones,
        workingTime: a.working_time
      }
    end.to_json
  end

  def all_addresses
    addresses.ordered.includes(:phone_numbers)
  end

  def next_color
    MARKER_COLORS[addresses.count % MARKER_COLORS.length]
  end

  def not_payed?
    !payed?
  end

  def payed?
    self.firm.bonus_subscriptions.signing_object(self.city).first.present?
  end

  private
  def add_details
    count = firm.city_firms.count rescue 0
    self.base = count.zero?
    self.rating = count+1
    self.dealer = Firm.dealers.by_city(self.city).first
  end

  def paranoid_recover!
    self.recover
    count = firm.city_firms.count rescue 0
    self.base = count.eql?(1)
    self.rating = count
    self.save
  end
end