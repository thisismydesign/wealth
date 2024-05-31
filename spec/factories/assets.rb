# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Currency.unique.name }
    ticker { Faker::Currency.unique.code } # This can sometimes fail, possibly due to validation being case insensitive
    asset_type
  end
end
