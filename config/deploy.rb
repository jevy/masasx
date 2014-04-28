$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "bundler/capistrano"
require "rvm/capistrano"                  # Load RVM's capistrano plugin.

set :rvm_type, :user

set :application, "masasx"
set :domain, "ci.masas-sics.ca"
set :repository, "git://github.com/jevy/masasx.git"
set :use_sudo, false
set :deploy_to, "/var/www/masasx"
set :scm, :git
set :user, "rails"

role :app, domain
role :web, domain
role :db, domain, :primary => true

set :normalize_asset_timestamps, false

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Copy the database file"
  task :database_file, :roles => :app do
    run "cp #{shared_path}/secret/database.yml #{current_release}/config/"
  end
end

before "deploy:finalize_update", "deploy:database_file"

        require './config/boot'
        require 'airbrake/capistrano'
