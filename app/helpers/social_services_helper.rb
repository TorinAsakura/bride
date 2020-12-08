module SocialServicesHelper
  def request_from_social_services?
    @referrer_path = session[:socials_referrer_path]
  end

  def clear_social_request_referrer_path
    session[:socials_referrer_path] = nil
  end

  def set_referrer_for_social_services
    session[:socials_referrer_path] = request.referrer
  end
end