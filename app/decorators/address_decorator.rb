class AddressDecorator < Draper::Decorator
  delegate_all

  def full_address
    h.simple_format(object.full_address)
  end

  def contacts_address
    object.full_address
  end

  def name
    base_name = object.name.strip
    base_name = base_name.gsub(/^\"/, '').gsub(/\"$/, '') if base_name.match(/^\"/)
    base_name = base_name.gsub(/^\«/, '').gsub(/\»$/, '') if base_name.match(/^\«/)
    base_name
  end

  def site_url
    site = object.site
    site = site.gsub('https', '').gsub('http', '').gsub(':', '').gsub('//', '')
    "http://#{site}"
  end
end
