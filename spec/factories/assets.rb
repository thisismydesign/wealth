# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Currency.unique.name }
    ticker { Faker::Currency.unique.code }
    asset_type
  end
end
