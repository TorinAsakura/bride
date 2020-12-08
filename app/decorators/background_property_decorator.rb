class BackgroundPropertyDecorator < Draper::Decorator
  delegate_all

  def style(demo = false)
    bg = model
    url = bg.header? ? bg.image_url(:thumb) : bg.image_url
    v_position = bg.header? ? 'top' : 'center'
    bg_style = 'background-size: auto;'
    bg_style << "background-color: #{bg.color};" if bg.color.present?
    bg_style << "background-image: url(#{url});" if bg.image.present?
    bg_style << "background-attachment: #{bg.attachment};" if bg.attachment.present? && !demo
    bg_style << "background-position: #{v_position} #{bg.position};" if bg.position.present?
    bg_style << "background-repeat: #{bg.repeat};" if bg.repeat.present?

    bg_style
  end

  def header_color
    (c = model.header_color).present? ? "color: #{c}" : ''
  end

  def header_date_color
    (c = model.header_date_color).present? ? "color: #{c}" : ''
  end

  def image_class
    model.header? ? 'bg-header' : 'bg-background'
  end

  def image
    model.header? ? model.image_url(:thumb) : model.image_url(:preview)
  end

  def tag
    model.header? ? 'header' : 'body'
  end
end
