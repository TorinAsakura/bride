class Seating::PlanSerializer < ActiveModel::Serializer
  root false
  attributes :id
  has_many :tables

  def attributes
    hash = super
    if scope && (site = object.site).present? && site.can_edit?(scope)
      hash['owner'] = true
      hash['create_table_url'] = site_seating_plan_tables_url(site, subdomain:'')
    end
    hash
  end
end
