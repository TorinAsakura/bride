# encoding: utf-8
class Address < ActiveRecord::Base
  geocoded_by :city_address do |obj,results|
    if (geo = results.first).present?
      obj.location = geo.coordinates.join(', ')
      obj.coordinates = true
    end
  end

  acts_as_list scope: :city_firm

  belongs_to :city_firm, with_deleted: true
  has_many :phone_numbers
  attr_accessible :address, :contact_name, :name, :mobile_phone, :phone, :email, :icq, :vk,
                  :skype, :mailru, :site, :city_firm_id, :city_firm, :address, :phone_numbers_attributes,
                  :coordinates, :working_time_start, :working_time_end, :location, :explanation, :position

  validates :address, :name, presence: true

  accepts_nested_attributes_for :phone_numbers

  after_validation :geocode, if: lambda{ |obj| obj.address.present? && obj.address_changed? }

  after_initialize do
    self.working_time_start = Time.now.change(hour: 8, minute: 0) if self.working_time_start.blank?
    self.working_time_end = Time.now.change(hour: 17, minute: 0) if self.working_time_end.blank?
  end

  scope :ordered,    -> { order('position asc') }

  def full_address
    city_address.html_safe
  end

  def city_address
    city_name = city.try(:name)
    city_name_markers = %w(г. с.)
    no_city_name = city_name_markers.push(city_name).map{|m| address.scan(m).blank? && address.scan(m.mb_chars.upcase.to_s).blank?}.inject(:&)
    [no_city_name ? "г. #{city_name}" : nil, address].compact.join(', ')
  end

  def firm
    city_firm.firm
  end

  def city
    city_firm.city
  end

  def all_phones
    [phone, mobile_phone, phone_numbers.map(&:phone)].flatten.reduce('') do |result, number|
      result + (number.blank? ? '' : ", #{number}")
    end
  end

  def working_time
    "#{working_time_start.to_s(:time)} : #{working_time_end.to_s(:time)}" if working_time_start && working_time_end
  end
end