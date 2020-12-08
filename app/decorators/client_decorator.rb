class ClientDecorator < Draper::Decorator
  delegate_all

  def wedding_city_name
    if object.wedding_city
      object.wedding_city.name
    else
      object.user.wedding_city
    end
  end

  def link_to_first_name
    h.link_to(object.firstname, user.profile_url)
  end

  def user
    object.user.decorate
  end
end
