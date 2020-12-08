class Bonus::Service::AddSphere < Bonus::Service
  has_many :subscriptions, class_name: 'Bonus::Subscription', foreign_key: :service_id
  has_many :signing_services, class_name: 'Bonus::SigningService', foreign_key: :service_id

  def pro
    Bonus::Service::Pro.find('pro') rescue nil
  end

  def signing_object_name
    'FirmCatalog'
  end

  def signing_base_class_name
    'Sphere'
  end

  def has_subscriptions?
    !self.subscriptions.count.zero?
  end

  def price(firm, firm_catalog)
    return 0.to_money unless pro
    service = (parent = firm_catalog.parent).present? &&
        (parents = firm.all_firm_catalogs.map(&:parent).compact.uniq).present? &&
        parents.include?(parent) ? Bonus::Service::AddSphere.find('add-subcategory') : self
    (pro.firm_catalog_price(firm_catalog)*service.coefficient).to_nice
  end

  def coefficient
    (100-discount.to_f)/100
  end

  def uniq_form?
    true
  end
end