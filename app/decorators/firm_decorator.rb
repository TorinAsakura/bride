class FirmDecorator < Draper::Decorator
  delegate_all

  def name
    base_name = object.name.strip
    base_name = base_name.gsub(/^\"/, '').gsub(/\"$/, '') if base_name.match(/^\"/)
    base_name = base_name.gsub(/^\«/, '').gsub(/\»$/, '') if base_name.match(/^\«/)
    base_name
  end

  def bonus_color_class
    object.cutaway_colored? ? 'sv-featured' : nil
  end

  def cutaway
    case object.bonus_status
      when 3, 4 #vip and vip with color
        'vip'
      when 2, 1 #pro and pro with color
        'pro'
      else
        'base'
    end
  end

  def phone
    (address = object.base_city_firm.try(:base_address)).present? ? address.mobile_phone.presence || address.phone.presence : nil
  end

  def money
    object.purse.amount.format(html: true).html_safe
  end

  def catalogs
    spans = []
    object.spheres.each do |sphere|
      spans << h.content_tag(:span, sphere.firm_catalog.name) if sphere.persisted?
    end
    spans.join.html_safe
  end

  def body_bg_style
    if (background_image = model.background_image).present?
      background_image.decorate.style
    else
      ''
      # TODO add after select custom body background image
    end
  end
end
