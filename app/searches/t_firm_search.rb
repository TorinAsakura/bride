class TFirmSearch < Searchlight::Search
  search_on TFirm.includes(:firm_catalog).includes(:city)

  searches :fragment, :city_id, :firm_catalog_ids

  def search_fragment
    search_param = fragment + '%'
    search.where('t_firms.name ILIKE ? OR t_firms.extended_name ILIKE ?', search_param, search_param) 
  end

  def search_city_id
    search.where('cities.id = ? or cities.slug = ?', city_id.to_i, city_id)
  end

  def search_firm_catalog_ids
    search.where('firm_catalogs.id IN (?)', firm_catalog_ids.split(','))
  end
end
