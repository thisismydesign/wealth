# Wealth Project Guidelines

## Commands
- Start server: `docker compose up`
- Run all tests: `docker compose exec web bundle exec rspec`
- Run single test: `docker compose exec web bundle exec rspec path/to/spec_file.rb:LINE_NUMBER`
- Check code style and auto-fix in one step: `docker compose exec web bin/rubocop -A [files]`

## Code Style
- Ruby version: 3.2.2
- Add `# frozen_string_literal: true` to all Ruby files
- Follow RuboCop rules as defined in .rubocop.yml
- Asset tickers must be uppercase
- Model associations use `dependent: :restrict_with_exception` 
- Use `belongs_to` with `optional: true` when needed
- Database-agnostic queries (works with SQLite/PostgreSQL)
- Clear and descriptive naming for methods and variables
- Use service objects for business logic (inherit from ApplicationService)
- Add validations for all model attributes

## Architecture
- Rails 8 with ActiveAdmin v4 for admin interface
- Authorization with Pundit policies
- Follow resource-based routing
- Use Tailwind CSS for styling
