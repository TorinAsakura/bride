class FirmSearch < Searchlight::Search
  search_on Firm.includes(:firm_catalogs).includes(:cities).includes(user: :friendships)

  searches :fragment, :city_id, :firm_catalog_ids, :owner_id

  def search_fragment
    search_param = fragment + '%'
    search.where('firms.name ILIKE ? OR firms.extended_name ILIKE ?', search_param, search_param) 
  end

  def search_city_id
    search.where('cities.id = ? or cities.slug = ?', city_id.to_i, city_id)
  end

  def search_firm_catalog_ids
    search.where('firm_catalogs.id IN (?)', firm_catalog_ids.split(','))
  end

  def search_owner_id
    search.where('friendships.friend_id = ?', owner_id)
  end
end
