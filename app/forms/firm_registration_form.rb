class FirmRegistrationForm < UserRegistrationForm

  attribute :name, String
  attribute :extended_name, String
  attribute :firm_catalog_ids, Array[Integer]
  attribute :parent_token, String
  attribute :city_ids, Array[Integer]

  validates :name, :firm_catalog_ids, presence: true

  def city
    City.find_by_id(city_ids)
  end

  def firm_catalog
    FirmCatalog.find_by_id(firm_catalog_ids)
  end

  private
  def build_profileable
    Firm.new(name: name, extended_name: extended_name, firm_catalog_ids: firm_catalog_ids, parent_token: parent_token, city_ids: city_ids.map(&:to_i).uniq-[0])
  end
end
