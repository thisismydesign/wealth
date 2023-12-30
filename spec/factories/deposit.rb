# frozen_string_literal: true

FactoryBot.define do
  factory :deposit do
    date { DateTime.now }
    amount { Faker::Number.decimal }
    asset
  end
end
