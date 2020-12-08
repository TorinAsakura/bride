# encoding: utf-8
CarrierWave::SanitizedFile.sanitize_regexp = /[^a-zA-Zа-яА-ЯёЁ0-9\.\_\-\+\s\:]/
CarrierWave.configure do |config|
  config.fog_credentials = {
    provider:               'AWS',
    aws_access_key_id:      ChelnySvadba.config.amazon_s3_key,
    aws_secret_access_key:  ChelnySvadba.config.amazon_s3_secret,
    region:                 'eu-west-1'
  }
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :fog
  end

  config.cache_dir = "#{Rails.root}/tmp/uploads"

  config.fog_directory  = case Rails.env
                            when 'development' then 'svadba-develop'
                            when 'test' then 'svadba-test'
                            else 'svadba'
                          end
  config.fog_use_ssl_for_aws = false

  # config.asset_host       = "http://#{config.fog_directory}.s3.amazonaws.com"
  # end
end
