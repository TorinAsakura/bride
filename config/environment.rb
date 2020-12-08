# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
ChelnySvadba::Application.initialize!

my_date_formats = { :default => '%d.%m.%Y' }
#Time::DATE_FORMATS.merge!(my_date_formats)
Date::DATE_FORMATS.merge!(my_date_formats)
