class SiteDecorator < Draper::Decorator
  delegate_all

  def title
    "#{object.description.presence || object.name} на Svadba.org"
  end

  def body_bg_style
    if (background_image = model.background_image).present?
      background_image.decorate.style
    else
      ''
      # TODO add after select custom body background image
    end
  end

  def body_image_url
    model.background_image.presence.try(:image_url)
  end

  def header_bg_style
    if (header_image = model.header_image).present?
      header_image.decorate.style
    else
      ''
      # TODO add after select custom header background image with colors
    end
  end

  def header_color_style
    if (header_image = model.header_image).present?
      header_image.decorate.header_color
    else
      ''
    end
  end

  def header_date_color_style
    if (header_image = model.header_image).present?
      header_image.decorate.header_date_color
    else
      ''
    end
  end
end
