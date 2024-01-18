# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    priceable { [association(:trade), association(:income)].sample }
    asset
    amount { Faker::Number.decimal }
  end
end
