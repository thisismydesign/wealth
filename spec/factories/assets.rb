# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Currency.name }
    ticker { Faker::Currency.code }
    asset_source
    asset_type
  end
end
