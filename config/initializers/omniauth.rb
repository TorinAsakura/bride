Rails.application.config.middleware.use OmniAuth::Builder do
  if !(Rails.env == "test")
    Secrets::secret[Rails.env]['omniauth'].each do |service, definition|
      params = {}
      definition['scope'] and (params[:scope] = definition['scope'])
      provider service.to_sym, definition['key'], definition['secret'], params
    end
  end
end

#Rails.application.config.middleware.use OmniAuth::Builder do
#  provider :facebook, ChelnySvadba.config.facebook_app_id, ChelnySvadba.config.facebook_app_secret
#  provider :vkontakte, ChelnySvadba.config.vkontakte_app_id, ChelnySvadba.config.vkontakte_app_secret
#  provider :mailru, ChelnySvadba.config.mailru_app_id, ChelnySvadba.config.mailru_app_private, :private_key => ChelnySvadba.config.mailru_app_secret #, :callback_url => 'http://solenko.dev:3000/auth/mailru/callback'
#  provider :instagram, ChelnySvadba.config.instagram_app_id, ChelnySvadba.config.instagram_app_secret
#  provider :odnoklassniki, ChelnySvadba.config.odnoklassniki_app_id, ChelnySvadba.config.odnoklassniki_app_secret, :public_key => ChelnySvadba.config.odnoklassniki_app_public
#  provider :twitter, ChelnySvadba.config.twitter_app_id, ChelnySvadba.config.twitter_app_secret
#end
