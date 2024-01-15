# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Defaults
gem 'bootsnap', require: false
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.2'
gem 'tzinfo-data', platforms: %i[windows jruby]

# Initialize env early
gem 'dotenv-rails', groups: %i[development test], require: 'dotenv/rails-now'

# Gems used by the app
gem 'activeadmin'
gem 'activeadmin_addons'
gem 'chartkick' # Charts
gem 'faraday' # HTTP client
gem 'nokogiri' # Parse MNB exchange rates from HTML
gem 'sass-rails' # Needed for ActiveAdmin
gem 'sidekiq'
gem 'sprockets' # Needed for ActiveAdmin

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', '~> 6.1.0'
end

group :development do
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'shoulda-matchers', '~> 6.0'
  gem 'simplecov', require: false
end
