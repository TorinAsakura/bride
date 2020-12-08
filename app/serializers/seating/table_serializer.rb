class Seating::TableSerializer < ActiveModel::Serializer
  attributes :id, :form, :title, :height, :width, :deg, :position

  has_many :seats

  def position
    {
        left: object.left_position,
        top: object.top_position
    }
  end

  def attributes
    hash = super
    if scope && (site = object.site).present? && site.can_edit?(scope)
      hash['table_url'] = site_seating_plan_table_url(site, object, subdomain:'')
      hash['create_seat_url'] = site_seating_plan_table_seats_url(site, object, subdomain:'')
    end
    hash
  end
end
