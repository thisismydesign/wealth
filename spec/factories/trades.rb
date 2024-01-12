# frozen_string_literal: true

FactoryBot.define do
  factory :trade do
    date { DateTime.now }
    from { association(:asset) }
    to { association(:asset) }
    from_amount { Faker::Number.decimal }
    to_amount { Faker::Number.decimal }
    asset_holder
  end
end
