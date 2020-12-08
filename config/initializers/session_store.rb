# Be sure to restart your server when you modify this file.

ChelnySvadba::Application.config.session_store :cookie_store, key: '_chelny_svadba_session', domain: {
    production: ['.mysvadba.org', '.svadba.org', '.mysvadba.ru', '.mysvadba.com', '.my-svadba.org'],
    development: ['lvh.me', 'localhost']
}.fetch(Rails.env.to_sym, :all)# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# ChelnySvadba::Application.config.session_store :active_record_store
