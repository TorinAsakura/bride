require 'rubygems'
require 'daemons'

APP_DIR = File.expand_path('../..', __FILE__)

Daemons.run_proc(
  'scheduler',
  dir_mode:   :normal,
  dir:        File.join(APP_DIR, 'tmp', 'pids'),
  multiple:   false,
  backtrace:  true,
  monitor:    false,
  log_output: true,
  log_dir:    File.join(APP_DIR, 'log')
) do
  Dir.chdir APP_DIR
  require "#{Dir.pwd}/config/environment.rb"
  require 'rufus/scheduler'
  scheduler = Rufus::Scheduler.new
 
  #NOTE uncomment after work with fake users has gone
  # scheduler.every('2d') do
  #   puts "start delete account that hasn\'t been confirmed after a 14 days #{Time.now}"
  #   system("RAILS_ENV=#{Rails.env} rake delete_unconfirmed_users")
  #   puts "end delete account #{Time.now}"
  # end

  scheduler.every('23h') do
    puts "touch firms bonus status  #{Time.now}"
    system("RAILS_ENV=#{Rails.env} rake bonus:touch:firms")
    puts "end touch firms bonus status"
  end

  scheduler.join
end
