class Bonus::Service::AddCity < Bonus::Service
  has_many :subscriptions, class_name: 'Bonus::Subscription', foreign_key: :service_id
  has_many :signing_services, class_name: 'Bonus::SigningService', foreign_key: :service_id

  def pro
    Bonus::Service::Pro.find('pro') rescue nil
  end

  def signing_object_name
    'City'
  end

  def signing_base_class_name
    'CityFirm'
  end

  def has_subscriptions?
    !self.subscriptions.count.zero?
  end

  def price(firm, city)
    return 0.to_money unless pro
    (pro.city_price(firm, city)*coefficient(firm)).to_nice
  end

  def coefficient(firm)
    [(1-(self.discount.to_f*firm.all_cities.count/100)), 0.7].max
  end

  def uniq_form?
    true
  end
end