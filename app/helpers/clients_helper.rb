# encoding: utf-8
module ClientsHelper
  def navigation_link_to(title, path, position = 'right')
    link = inner_link_to_page(title, path, position)
    content_tag('li', class: current_page?(path) ? 'active' : nil) { link }
  end

  def inner_link_to_page(title, path, position)
    link_to path do
      css_class = position == 'left' ? 'arr left' : 'arr right'
      title.html_safe + content_tag('i', '', class: css_class)
    end
  end

  def link_to_minisite(site, title = nil, options = {}, &block)
    url = site.name.present? ? ['http://', site.name, '.', request.host_with_port].join : site_path(site)
    if block_given?
      link_to url, options, &block
    else
      title = site.name.present? ? [site.name, '.', request.host_with_port].join : 'Мини-сайт' if title.nil?
      link_to title, url, options
    end
  end

  def minisite_ideas_path(site)
    if (site_name = site.try(:name)).present?
      link_to 'Перейти в «Мои идеи»', minisite_my_ideas_root_url(subdomain: site_name), class: 'link-style'
    else
      link_to 'Создать мини-сайт', new_site_path, class: 'link-style'
    end
  end

  def gender_class client
    if client.gender.nil?
      'sv-client-fullname__gender_people'
    else
      client.gender ? 'sv-client-fullname__gender_male' : 'sv-client-fullname__gender_female'
    end
  end

  def search_params_to_path params_hash
    params_hash.map { |k, v| "search[#{k}]=#{v}" }.join('&')
  end

  def array_photos_block photos
    order = case photos.count
              when 1 then
                [0, 2, 1, 3]
              when 2 then
                [1, 2, 0, 3]
              when 3 then
                [2, 0, 1, 3]
              when 4 then
                [3, 1, 2, 0]
              else
                [4, 2, 3, 1]
            end
    photos.values_at *order
  end

  def path_search_posts_with_type client, type
    if current_page?(action: 'show')
      client_path(@client, search: {show_type: type})
    else
      client_posts_path(@client, search: {show_type: type})
    end
  end

  def class_for_type_link active_type, default_type
    'sv-posts-search-form__link' + (active_type == default_type ? ' sv-posts-search-form__link_active' : '')
  end
end
