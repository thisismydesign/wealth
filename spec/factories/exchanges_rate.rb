# frozen_string_literal: true

FactoryBot.define do
  factory :exchange_rate do
    rate { Faker::Number.decimal }
    to { association(:asset) }
    from { association(:asset) }
    date { DateTime.now }
  end
end
