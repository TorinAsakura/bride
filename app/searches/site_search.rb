# encoding: utf-8
class SiteSearch < Searchlight::Search
  search_on Site.includes(client: :wedding)

  searches :city_id, :fullname, :day, :month, :year 

  def search_city_id
    search.where('clients.wedding_city_id = ?', city_id)
  end

  def search_fullname
    str_ar = fullname.split(' ')
    int_ar = str_ar.map { |i| i.to_i }
    search.where('clients.id IN (?) OR clients.firstname IN (?) OR clients.lastname IN (?)', int_ar, str_ar, str_ar)
  end

  def search_day
    search.where('Extract(day from weddings.wedding_date) = ?', day)
  end

  def search_month
    search.where('Extract(month from weddings.wedding_date) = ?', month)
  end

  def search_year
    search.where('Extract(year from weddings.wedding_date) = ?', year)
  end
end
