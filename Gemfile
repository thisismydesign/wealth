# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Defaults
gem 'bootsnap', require: false
gem 'importmap-rails' # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'kamal', '2.5.2'
gem 'propshaft' # The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.0.0'
gem 'sqlite3'
gem 'stimulus-rails' # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'thruster', require: false # Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'turbo-rails' # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'tzinfo-data', platforms: %i[windows jruby]

# Gems used by the app
gem 'activeadmin', '4.0.0.beta13'
gem 'chartkick' # Charts
gem 'cssbundling-rails', '~> 1.4' # Required by ActiveAdmin, alternative to tailwindcss-rails (do not mix!)
gem 'devise' # Authentication
gem 'faraday' # HTTP client
gem 'nokogiri' # Parse MNB exchange rates from HTML
gem 'pundit' # Authorization
gem 'rollbar' # Monitoring
gem 'solid_queue', '1.1.3' # ActiveJob backend
gem 'solid_queue_dashboard', '~> 0.2.0'

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
