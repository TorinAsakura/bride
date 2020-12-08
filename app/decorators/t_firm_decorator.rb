class TFirmDecorator < Draper::Decorator
  delegate_all

  def name
    base_name = object.name.strip
    base_name = base_name.gsub(/^\"/, '').gsub(/\"$/, '') if base_name.match(/^\"/)
    base_name = base_name.gsub(/^\«/, '').gsub(/\»$/, '') if base_name.match(/^\«/)
    base_name
  end

  def cutaway
    'base'
  end

  def catalogs
    h.content_tag(:span, object.firm_catalog.name).html_safe
  end
end
