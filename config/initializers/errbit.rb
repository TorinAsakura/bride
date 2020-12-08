Airbrake.configure do |config|
  config.api_key = '4984507bd54748d50d05e72add1696b8'
  config.host    = 'mysvadba-errbit.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
