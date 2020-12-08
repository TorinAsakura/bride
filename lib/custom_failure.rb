class CustomFailure < Devise::FailureApp
  def redirect_url
    new_user_session_url(subdomain: false)
  end

  # You need to override respond to eliminate recall
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def store_location_for(resource_or_scope, location)
    session_key = stored_location_key_for(resource_or_scope)
    if location
      uri = URI.parse(location)
      session[session_key] = request.protocol + request.host + request.port_string + [uri.path.sub(/\A\/+/, '/'), uri.query].compact.join('?')
    end
  end
end
