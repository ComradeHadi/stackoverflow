require 'rails_helper'
require 'capybara/rspec'
require 'capybara/webkit/matchers'
require 'headless'

Capybara.javascript_driver = :webkit

RSpec.configure do |config|
  config.include Capybara::Webkit::RspecMatchers, type: :feature
  config.include SphinxHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
    ThinkingSphinx::Test.init
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) { DatabaseCleaner.strategy = :transaction }
  config.before(:each) { Sidekiq::Worker.clear_all }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each, js: true) { page.driver.allow_url('stackoverflow.local') }
  config.before(:each, js: true) { ActionMailer::Base.deliveries = [] }
  config.before(:each, js: true) { index }
  config.before(:each) { DatabaseCleaner.start }

  config.after(:each) { DatabaseCleaner.clean }
  config.after(:each) { ActiveJob::Base.queue_adapter.enqueued_jobs = [] }
  config.after(:each) { ActiveJob::Base.queue_adapter.performed_jobs = [] }
  config.after(:each, js: true) { ActionMailer::Base.deliveries = [] }

  config.after(:each, js: true) { sleep 0.3 }
  config.after(:suite) { FileUtils.rm_rf(Dir.glob('public/uploads/*')) }
end

headless = Headless.new
headless.start
at_exit { headless.stop }
