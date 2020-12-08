class Seating::SeatSerializer < ActiveModel::Serializer
  attributes :id, :guest_type, :side, :gender, :position, :guest

  def attributes
    hash = super
    if scope && (site = object.site).present? && site.can_edit?(scope)
      hash['seat_url'] = site_seating_plan_table_seat_url(site, object.table, object, subdomain:'')
    end
    hash
  end
end
