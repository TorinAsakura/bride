# encoding: utf-8
module ApplicationHelper
  include Access

  def bootstrap_flash
    flash_messages = []

    flash.each do |type, message|

      message_array = []
      if message.class == Array
        message_array = message
      else
        message_array << message
      end

      message_array.each do |msg|
        type = :success if type == :notice
        type = :error if type == :alert
        text = content_tag(:div, link_to("x", "#", :class => "close", "data-dismiss" => "alert") + msg, :class => "alert fade in alert-#{type}")
        flash_messages << text if message
      end
    end
    flash_messages.join("\n").html_safe
  end

  def public_roles
    Role.public_roles
  end

  def edit_dom_id(obj)
    dom_id(obj, :edit)
  end

  def new_dom_id(obj)
    dom_id(obj, :new)
  end
  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def substr(string, end_char=500, start_char=0)
    return nil unless string.class == String
    if string.size > end_char
      string[start_char..end_char-2] + '…'
    else
      string
    end
  end

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block)}
    Rails.env.production? ? uri = URI.parse("http://mysvadba.org:9292/faye") : uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  def nl2br(text)
    h(text).gsub("\n\r",'<br>').gsub("\r", '').gsub("\n", '<br>').html_safe rescue ''
  end

  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + '_fields', f: builder)
    end
    link_to(name, '#', class: 'add_fields', data: {id: id, fields: fields.gsub('\n', '')})
  end

  def text_in_quotes(text)
    "&laquo;#{h(text)}&raquo;".html_safe rescue ''
  end

  def format_phone(text, show_all = false)
    return nil unless text.class == String
    text = text.split(',')[0]
    result = show_all ? number_to_phone(text.gsub('+', ''), area_code: true) : text[0..-9].to_s + '*' * text[-8..-3].to_s.length + text[-2..-1].to_s
    result.gsub!(/\ /, '&nbsp;')
    result.html_safe
  end

  def get_all_cities_with_id
    City.where('cities.name IS NOT NULL').map{|c| [c.name, c.id]}
  end

  def get_day date
    return nil if date.class != Date && date.class != DateTime
    date.day
  end

  def get_month date
    return nil if date.class != Date && date.class != DateTime
    date.month
  end

  def get_year date
    return nil if date.class != Date && date.class != DateTime
    date.year
  end

  def months_list
    result = []
    I18n.t('date.month_names').compact.each_with_index{|m, i| result << [m,i+1]}
    result
  end

  def pluralize n, *variants
    raise ArgumentError, 'Must have a Numeric as a first parameter' unless n.is_a?(Numeric)
    raise ArgumentError, 'Must have at least 3 variants for pluralization' if variants.size < 3
    raise ArgumentError, 'Must have at least 4 variants for pluralization' if (variants.size < 4 && n != n.round)
    case n.to_s.last.to_i
    when 1 then variants[0]
    when 2,3,4 then variants[1]
    else
      variants[2]
    end
  end

  def to_gender gender
    case gender
    when ''
      'Неизвестно'
    when true
      'Мужчина'
    when false
      'Женщина'
    end
  end

  def gender_collection
    [['Мужской', true] ,['Женский', false]]
  end

  def gender_eng gender
    gender ? 'male' : 'female'
  end

  def main_domain_link(url = '')
    request.protocol + request.domain + request.port_string + url
  end

  def firm_link firm, path = ''
    root_url(subdomain: firm.slug) + path
  end

  def auto_link_text(text)
    auto_link simple_format(text), html: { rel: :nofollow }
  end

  def auto_link_substr(text)
    auto_link substr(text), html: { rel: :nofollow }
  end

  def user_profile user
    user.profileable.class.to_s.downcase
  end

  def city_editor(city, update_path = city_update_path, autocomplete_path = city_autocomplete_path)
    random_id = "city_#{rand(10000)}"
    content_for(:javascripts, javascript_tag("$(function() { new CityEditor($('##{random_id}')); });"))
    data = {
      :value => city.try(:id),
      :update_path => update_path,
      :autocomplete_path => autocomplete_path
    }

    unless city.blank?
      city_string = city.name + ' ' + city.region.name
    end
    content_tag :span, :id => random_id, class: 'city-name', :data => data do
      city_string
    end
  end

  def wedding_cities
    City.enabled_for_firms.ordered.includes(region: :country)
  end

  def edit_user_wedding_city_link user, city
    link = user.client? ? update_wedding_city_client_path(user.client.id, city_id: city.id) : update_wedding_city_firm_path(user.firm.id, city_id: city.id)
    link_to(city.name, link, class: 'wedding-city', method: :post, title: city.full_name, remote: true)
  end

  def wedding_invite_count client
    client.invited.count
  end

  def tab_active?(url)
    'active' if request.fullpath == url
  end

  def sv_wrapper_class
    if  controller_name != 'task_categories' && controller_name != 'scripts'
      'sv-wrapper'
    end
  end

  def user_link_page resource
    resource.is_a?(Client) ? client_url(resource) : firm_link(resource)
  end

  def wrapper_class
    controllers = %w(idea/ideas idea/sections idea/categories)
    controllers.include?(params[:controller]) ? 'sv-wrapper-ideas' : 'sv-wrapper'
  end

  def url_with_protocol(url)
    url.blank? ? url : (/^http/.match(url) ? url : "http://#{url}")
  end

  def short_username
    if current_user.name.present?
      current_user.full_name
    else
      current_user.client? ? 'Пользователь' : 'Фирма'
    end
  end
end
