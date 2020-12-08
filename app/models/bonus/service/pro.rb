class Bonus::Service::Pro < Bonus::Service

  has_many :prices, class_name: 'Bonus::Price', foreign_key: :service_id do
    def sphere(sphere)
      where(bonus_prices: {firm_catalog_id: sphere.try(:firm_catalog_id)}).first_or_initialize
    end
    def firm_catalog(firm_catalog)
      where(bonus_prices: {firm_catalog_id: firm_catalog.id}).first_or_initialize
    end
  end

  has_many :city_ratios, class_name: 'Bonus::CityRatio', foreign_key: :service_id do
    def city(city)
      where(bonus_city_ratios: {city_id: city.try(:id)}).first_or_initialize
    end
  end
  
  has_many :seasonal_factors, class_name: 'Bonus::SeasonalFactor', foreign_key: :service_id do
    def today
      where(bonus_seasonal_factors: {month: Time.zone.now.month}).first
    end
  end

  has_many :packages, class_name: 'Bonus::Package', foreign_key: :service_id
  has_many :loyalties, class_name: 'Bonus::Loyalty', foreign_key: :service_id

  has_many :city_dealer_percents, class_name: 'Bonus::CityDealerPercent', foreign_key: :service_id do
    def city(city)
      where(bonus_city_dealer_percents: {city_id: city.id}).first_or_initialize
    end
  end
  has_many :subscriptions, class_name: 'Bonus::Subscription', foreign_key: :service_id
  has_many :signing_services, class_name: 'Bonus::SigningService', foreign_key: :service_id

  def has_subscriptions?
    !self.subscriptions.count.zero?
  end

  def pro?
    true
  end

  def price(firm, months_count = 12)
    amount = firm.all_spheres.map{|sphere| (p = self.prices.sphere(sphere)).persisted? ? p.amount : nil}.compact.max || self.amount
    city_ratio = firm.all_cities.map{|city| self.city_ratios.city(city).coefficient}.max || 1
    seasonal_factor = self.seasonal_factors.today.coefficient
    loyalty = firm.bonus_signing_services.service(self).first.try(:select_loyalty) || 1
    price = amount*city_ratio*months_count*loyalty
    price = price*seasonal_factor if months_count.eql?(12)
    price.to_nice
  end

  def city_price(firm, city)
    amount = (sphere_price = self.prices.sphere(firm.sphere)).persisted? ? sphere_price.amount : self.amount
    city_ratio = self.city_ratios.city(city).coefficient
    amount*city_ratio*12
  end

  def firm_catalog_price(firm_catalog)
    amount = (sphere_price = self.prices.firm_catalog(firm_catalog)).persisted? ? sphere_price.amount : self.amount
    amount*12
  end

  def icon
    'icon-lock-open'
  end
end