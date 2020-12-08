# encoding: utf-8
class ClientSearch < Searchlight::Search
  search_on Client.includes(:communities).includes(user: :friendships)

  searches :gender, :city_id, :fullname, :firstname, :lastname, :id, :wedding_id, :friendship_status,
    :birthday, :day, :month, :year, :community_id, :age_min, :age_max, :owner_id, :only_online, :without_avatar

  def search_gender
    search.where(gender: gender)
  end

  def search_city_id
    search.where(city_id: city_id)
  end

  def search_fullname
    str_var = fullname + '%'
    int_var = fullname.to_i
    search.where('clients.id = ? OR clients.firstname ILIKE ? OR clients.lastname ILIKE ?', int_var, str_var, str_var)
  end

  def search_firstname
    search.where(firstname: firstname)
  end

  def search_lastname
    search.where(lastname: lastname)
  end

  def search_id
    search.where(id: id)
  end

  def search_wedding_id
    search.where(wedding_id: wedding_id)
  end

  def search_day
    search.where('Extract(day from birthday) = ?', day)
  end

  def search_month
    search.where('Extract(month from birthday) = ?', month)
  end

  def search_year
    search.where('Extract(year from birthday) = ?', year)
  end

  def search_community_id
    search.where('clients_communities.community_id = ?', community_id)
  end

  def search_age_min
    search.where('clients.birthday < ?', Date.today - age_min.to_i.year)
  end

  def search_age_max
    search.where('clients.birthday > ?', Date.today - age_max.to_i.year)
  end

  def search_owner_id
    search.where('friendships.friend_id = ?', owner_id)
  end

  def search_only_online
    search.where('visited_at > ?', Time.now - CLIENT_TIMEOUT_MINUTES.minutes)
  end

  def search_friendship_status
    search.where('friendships.status = ?', friendship_status)
  end

  def search_without_avatar
    if without_avatar != 'true'
      search.where('clients.avatar <> \'\' AND clients.avatar IS NOT NULL ')
    end
  end
end
