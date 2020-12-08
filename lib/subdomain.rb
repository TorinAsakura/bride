module Subdomain
  @position = 1

  def self.position
    @position
  end

  def self.matches?(request)
    request.subdomain(@position).present? && request.subdomain(@position) != 'www'
  end
end
