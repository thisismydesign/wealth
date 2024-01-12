# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Currency.unique.name }
    ticker { Faker::Currency.unique.code }
    asset_type { AssetType.where(name: FactoryBot.build(:asset_type).name).first_or_create! }
  end
end
