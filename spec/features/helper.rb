require 'rails_helper'
require 'capybara/rspec'
require 'capybara/webkit/matchers'
require 'headless'

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include Capybara::Webkit::RspecMatchers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) { DatabaseCleaner.clean_with :truncation }
  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end

headless = Headless.new
headless.start
at_exit { headless.stop }
