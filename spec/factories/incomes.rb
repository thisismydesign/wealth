# frozen_string_literal: true

FactoryBot.define do
  factory :income do
    amount { Faker::Number.decimal }
    date { DateTime.now }
    income_type { IncomeType.where(name: FactoryBot.build(:income_type).name).first_or_create! }
    asset
    source { association(:asset) }
  end
end
