# Automatically precompile assets
load "deploy/assets"

# Execute "bundle install" after deploy, but only when really needed
require "bundler/capistrano"
require 'capistrano-nginx-unicorn'
require 'delayed/recipes'

set :rails_env, :production
set :is_staging, rails_env != :production

set :application, "#{('dev') if is_staging}svadba"
set :domain, "mysvadba.org"

set :use_sudo, false

set :hostingserver, domain
set :user,          "deploy"
set :port,          22

set :ssh_options, { :forward_agent => true }
set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
set :repository,  "git@github.com:XpaH/Svadba.org.git"
set :branch,      "master"
set :sudo_prompt, ""

set :bundle_without, [:darwin, :development, :test]

# Deploy via github
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"

set :nginx_pid, "/var/run/nginx.pid"
set :unicorn_workers, 4

set :shared_files,  %w(config/database.yml config/config.yml public/uploads)

role :web, hostingserver                          # Your HTTP server, Apache/etc
role :app, hostingserver                          # This may be the same as your `Web` server
role :db,  hostingserver, :primary => true	  # This is where Rails migrations will run
#role :db,  "your slave db-server here"		  # No slave at this moment


after "deploy:finalize_update", "deploy:update_shared_symlinks"

after "deploy", "deploy:migrate"
after "deploy:migrate", "faye_server:restart"

after "deploy:stop", "delayed_job:stop"
after "deploy:start", "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

namespace :deploy do
  task :update_shared_symlinks do
    shared_files.each do |path|
      # run "rm -rf #{File.join(release_path, path)}"
      run "ln -nfs #{File.join(deploy_to, "shared", path)} #{File.join(release_path, path)}"
    end
  end

  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end

  # Precompile assets only when needed
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      # If this is our first deploy - don't check for the previous version
      if remote_file_exists?(current_path)
        from = source.next_revision(current_revision)
        if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
          run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
        else
          logger.info "Skipping asset pre-compilation because there were no asset changes"
        end
      else
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      end
    end
  end
end

# Helper function
def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

desc "tail production log files"
task :tail_logs, :roles => :app do
  run "tail -f #{shared_path}/log/production.log" do |channel, stream, data|
    trap("INT") { puts 'Interupted'; exit 0; }
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

namespace :faye_server do
  desc "Start faye server"
  task :start do
    run "cd #{current_path};RAILS_ENV=production bundle exec rackup faye.ru -s thin -E production -D -P tmp/pids/faye.pid"
  end

  desc "Stop faye server"
  task :stop do
    run "cd #{current_path};if [ -f tmp/pids/faye.pid ] && [ -e /proc/$(cat tmp/pids/faye.pid) ]; then kill -9 `cat tmp/pids/faye.pid`; fi"
  end

  desc "Restart faye server"
  task :restart do
    stop
    start
  end
end

namespace :scheduler do
  desc 'Start the scheduler'
  task :start, roles: :app do
    run "cd #{current_release} && RAILS_ENV=production bundle exec ruby script/task_scheduler.rb start"
  end

  desc 'Stop the scheduler'
  task :stop, roles: :app do
    run "cd #{current_release} && RAILS_ENV=production bundle exec ruby script/task_scheduler.rb stop"
  end

  desc 'Restart the scheduler'
  task :restart, roles: :app do
    run "cd #{current_release} && RAILS_ENV=production bundle exec ruby script/task_scheduler.rb restart"
  end

  desc 'Status of scheduler'
  task :status, roles: :app do
    run "cd #{current_release} && ruby script/task_scheduler.rb status"
  end
end

