module IconsHelper
  def icon(icon, text="", html_options={})
    content_class = "icon-#{icon}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class

    html = content_tag(:i, nil, html_options)
    html << content_tag(:div, text, class: 'title-text') unless text.blank?
    html.html_safe
  end

  def ion(ion, text='', html_options = {})
    html_options[:class] = ["ion-#{ion}", html_options.delete(:class)].compact.join(' ')
    (content_tag(:i, nil, html_options) + text.to_s).html_safe
  end
end