module Secrets
  def self.secret
    @secrets ||= YAML::load( File::open(File::expand_path("../../#{keys_file}", __FILE__)))
  end

  def self.defined_providers
    secret[Rails.env]['omniauth'].each { |provider, pair|}.map { |provider| provider[0].to_sym }
  end

  def self.analytics
    secret[Rails.env]['analytics']
  end

  private
  def self.keys_file
    'secrets.yml'
  end
end
