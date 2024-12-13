# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Defaults
gem 'bootsnap', require: false
gem 'importmap-rails' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.2'
gem 'sprockets-rails' # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'stimulus-rails' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'turbo-rails' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'tzinfo-data', platforms: %i[windows jruby]

# Gems used by the app
gem 'activeadmin', '4.0.0.beta13'
gem 'chartkick' # Charts
gem 'cssbundling-rails', '~> 1.4' # Required by ActiveAdmin, alternative to tailwindcss-rails (do not mix!)
gem 'devise' # Authentication
gem 'faraday' # HTTP client
gem 'good_job' # ActiveJob backend
gem 'nokogiri' # Parse MNB exchange rates from HTML
gem 'pundit' # Authorization
gem 'rollbar' # Monitoring

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
