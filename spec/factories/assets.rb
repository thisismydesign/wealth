# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Currency.unique.name }
    ticker { Faker::Currency.unique.code.upcase }
    asset_type
  end
end
