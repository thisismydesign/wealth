# Wealth Project Guidelines

## Commands
- Start server: `docker compose up`
- Run all tests: `docker compose exec web bundle exec rspec`
- Run single test: `docker compose exec web bundle exec rspec path/to/spec_file.rb:LINE_NUMBER`
- Check code style and auto-fix in one step: `docker compose exec web bin/rubocop -A [files]`

## Code Style
- Ruby version: 3.2.2
- Follow RuboCop rules as defined in .rubocop.yml
- Clear and descriptive naming for methods and variables
- Use service objects for business logic (inherit from ApplicationService)
- Add validations for all model attributes
- No comments, make the code easy to understand as-is

## Architecture
- Rails 8 with ActiveAdmin v4 for admin interface
- Authorization with Pundit policies
- Follow resource-based routing
- Use Tailwind CSS for styling
- Solid Queue & ActiveJob for background jobs
