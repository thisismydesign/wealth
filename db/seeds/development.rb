# frozen_string_literal: true

# Seeds only for development, so dummy passwords are ok
User.where(email: 'admin@example.com').first_or_create! do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
end
