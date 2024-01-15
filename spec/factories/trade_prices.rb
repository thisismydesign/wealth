# frozen_string_literal: true

FactoryBot.define do
  factory :trade_price do
    trade
    asset
    amount { Faker::Number.decimal }
  end
end
