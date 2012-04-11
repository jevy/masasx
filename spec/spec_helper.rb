require 'rubygems'
require 'spork'

unless Spork.using_spork?
  require 'simplecov'
end

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  require 'rails/application'
  # ActiveAdmin / Devise workaround for spork
  # Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  RSpec.configure do |config|
    config.run_all_when_everything_filtered                = true
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus

    config.use_transactional_fixtures = true
  end

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
  require Rails.root.join('db','seeds')     # Load the seed data

  ActiveSupport::Dependencies.clear if Spork.using_spork?
end

Spork.each_run do
  FactoryGirl.reload
end
