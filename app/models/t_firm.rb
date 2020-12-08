class TFirm < ActiveRecord::Base
  belongs_to :firm_catalog
  belongs_to :city
  attr_accessible :address, :extended_name, :name, :phone, :rating

  scope :catalog_ordered, -> {order('t_firms.rating desc')}
  scope :ordered,         -> { order('t_firms.name asc')}

  paginates_per 50

  class << self
    def filtered(search=nil)
      t_firms = self.includes(:city)
      if search.present?
        ct = City.arel_table
        ft = self.arel_table
        t_firms = t_firms.where(ct[:name].matches("%#{search[:city]}%")) if search[:city].present?
        t_firms = t_firms.where(ft[:name].matches("%#{search[:name]}%")) if search[:name].present?
      end
      t_firms
    end

    def section_firms(catalog, city, search)
      firms = city ? city.t_firms : self
      if catalog
        fc_table = FirmCatalog.arel_table
        firms = firms.where(fc_table[:id].eq(catalog.id).or(fc_table[:parent_id].eq(catalog.id)))
      end

      firms = firms.named_like search if search.present?

      firms = firms.includes(:city).includes(:firm_catalog)
      firms = firms.catalog_ordered
      firms.uniq
    end

    def named_like(name)
      name ? where('t_firms.name like ?', "%#{name}%") : scoped
    end
  end
end
