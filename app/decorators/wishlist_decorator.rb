class WishlistDecorator < Draper::Decorator
  delegate_all

  def url_with_protocol
    /^http/.match(url) ? url : "http://#{url}"
  end
end



