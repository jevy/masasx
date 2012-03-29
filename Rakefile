#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'ci/reporter/rake/rspec'

Masasx::Application.load_tasks

desc 'Run rake spec and rake cucumber:all'
task :all do
  Rake::Task['spec'].invoke
  Rake::Task['cucumber:all'].invoke
end
