source 'https://rubygems.org'

gem 'rails', '3.2.18'

gem 'pg'
gem 'activerecord-postgres-hstore', '~> 0.7'
gem 'vkontakte_api', '~> 1.3'
gem "video_info"

gem 'searchlight'
gem "devise", ">= 2.1.2"
gem 'devise_invitable'
gem "devise-async"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'omniauth-instagram'
gem 'instagram'
gem 'omniauth-twitter'
gem 'vimeo'
gem 'ruby-duration'

gem 'simple_form'
gem "select2-rails"
gem 'jquery-tokeninput-rails'
gem 'autoprefixer-rails'

gem 'rmagick'
gem 'carrierwave', "0.9.0"
gem 'carrierwave-postgresql'
gem 'fog', '~> 1.23.0'
gem 'unf'
gem 'aasm'

gem 'jquery-datatables-rails', '~> 2.1.10.0.3'
gem 'lodash-rails'

gem "meta_search"

gem 'inherited_resources'

gem "symbolize", '~> 4.2.0', :require => "symbolize/active_record"
gem 'annotate', ">=2.5.0"

gem "haml", ">= 3.1.7"
gem 'kaminari'
gem 'html_slicer'

gem 'bourbon'
gem 'neat'

gem 'composite_primary_keys',"~> 5.0.13"

gem 'friendly_id', '~> 4.0.10'

gem 'rufus-scheduler'

#######
gem 'acts_as_commentable_with_threading'
gem 'acts-as-taggable-on'

gem 'thumbs_up'
gem 'acts_as_votable', '~> 0.5.0'

gem 'client_side_validations'
gem 'client_side_validations-simple_form'

# State machine
gem 'state_machine'

# Draper
gem 'draper', '~> 1.3'

gem "active_model_serializers"

gem 'nokogiri'

# JS EDITABLE
gem 'best_in_place'

# Dealer Invites
gem 'rack-affiliates'

gem 'rack-cors', :require => 'rack/cors'

# Paranoid
gem 'acts_as_paranoid', '~> 0.4.2'

gem 'acts_as_list', '~> 0.4.0'
gem 'awesome_nested_set', '~> 2.1.6'
gem 'the_sortable_tree', '~> 2.5.0'

# Payments
gem 'money-rails', git: 'https://github.com/RubyMoney/money-rails.git'

gem "recaptcha", require: "recaptcha/rails"

gem 'rails_autolink'

gem 'russian'
gem 'redactor-rails'

gem 'thin', '~> 1.5.1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  # gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
   gem 'therubyracer' #, :platforms => :ruby
   gem 'libv8'

  gem "jquery-fileupload-rails"

  gem 'uglifier', '>= 1.0.3'
  # gem 'bootstrap-sass', '~> 2.3.2.0'
  gem 'jquery-minicolors-rails', '~> 0.0.4'
  gem 'jquery-rails'
  gem 'jquery-ui-rails', :git => 'https://github.com/kristianmandrup/jquery-ui-rails.git'

  # Client Sites Only
  gem 'bootstrap-sass'
  gem 'animate-rails'
  gem 'sprockets-rails', '=2.0.0.backport1'
  gem 'sprockets', '=2.2.2.backport2'
  gem 'sass-rails', github: 'guilleiguaran/sass-rails', branch: 'backport'
end

group :production do
  gem "unicorn"
end

group :development do
  gem "spring"
  gem 'haml-rails', '>= 0.3.4'
  gem 'hpricot', '>= 0.8.6'
  gem 'ruby_parser', '~> 3.1.1'
  gem 'html2haml'
  gem 'quiet_assets'
  gem 'pry'
  gem 'rb-readline', '~> 0.5', require: false
  gem 'capistrano', '~> 2.15.5'
  gem 'capistrano-nginx-unicorn', '~> 0.0.8', require: false
  gem 'capistrano-ext', '~> 1.2.1'
  gem 'capistrano_colors'
  gem 'pry-stack_explorer'
  gem 'pry_debug', {group: [:test, :development]}.merge(ENV['RM_INFO'] ? {require: false} : {})
  # gem 'bullet' #for n+1 query detected
  gem 'mailcatcher'

  # for chrome
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  # gem 'rack-mini-profiler'
  gem 'letter_opener'
end

group :test do
  gem 'turn', ">= 0.8.3"
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'capybara'
  # gem 'selenium-webdriver'
  gem 'poltergeist'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  gem 'vydumschik'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
end


group :test, :darwin do
  gem 'rspec-nc'
  gem 'rb-fsevent'
  gem 'growl'
end

group :development, :darwin do
  gem 'puma'
end

gem 'hipchat'
gem 'faye' # for instance messages
gem 'delayed_job_active_record'

gem 'virtus'

gem 'geocoder'
gem 'airbrake'
