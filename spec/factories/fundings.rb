# frozen_string_literal: true

FactoryBot.define do
  factory :funding do
    date { DateTime.now }
    amount { Faker::Number.decimal }
    asset
    asset_holder
    user
  end
end
