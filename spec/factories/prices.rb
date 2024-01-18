# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    priceable { [association(:trade), association(:income)].sample }
    asset { [Asset.tax_base, Asset.trade_base].sample }
    amount { Faker::Number.decimal }
  end
end
