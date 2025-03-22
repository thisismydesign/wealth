# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    sequence(:name) { |n| "#{Faker::Currency.name} #{n}" }
    sequence(:ticker) { |n| "#{Faker::Currency.code.upcase}#{n}" }
    asset_type
  end
end
