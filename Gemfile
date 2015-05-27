source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgresql as the database for Active Record
# requires libpq-dev
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

gem 'slim-rails'
gem 'devise'

gem 'carrierwave'
gem 'remotipart'
gem 'nested_form'

gem 'private_pub'
gem 'thin'

gem 'responders'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

# Authorization Gem for Ruby on Rails
gem 'cancancan'

# OAuth v2 provider for Rails
gem 'doorkeeper'

# ActiveModel::Serializer implementation and Rails hooks
gem 'active_model_serializers'

# Optimized JSON - A fast JSON parser/serializer
gem 'oj'
gem 'oj_mimic_json'

# Recurring jobs for Sidekiq
gem 'whenever', require: false
# Simple, efficient background processing for Ruby
# requires redis-server
gem 'sidekiq'

# required by thinking-sphinx
# requires libmysqlclient-dev
gem 'mysql2'

# Sphinx plugin for ActiveRecord/Rails
# requires sphinxsearch
# requires gem mysql2
gem 'thinking-sphinx'

gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Remote multi-server automation and deployment tool (http://www.capistranorb.com)
group :development do
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'

  gem 'capybara'

  # requires qt5-default libqt5webkit5-dev
  # requires JavaScript runtime (nodejs, therubyracer)
  gem 'capybara-webkit'

  # requires xvfb
  gem 'headless'
  gem 'database_cleaner'

  # automatically run your specs (much like autotest)
  gem 'guard-rspec'

  # mutes assets pipeline log messages.
  gem 'quiet_assets'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem 'pry-rails'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'shoulda-matchers'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'rails_best_practices', require: false
  gem 'json_spec'
end
