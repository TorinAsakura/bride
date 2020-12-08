# encoding: utf-8
module BackgroundPropertiesHelper
  def body_bg_style style
    bg = style || BackgroundProperty.main_background

    return nil if bg.blank?
    bg.decorate.style
  end
end
