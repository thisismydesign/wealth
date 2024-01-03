# frozen_string_literal: true

FactoryBot.define do
  factory :asset do
    name { Faker::Currency.name }
    ticker { Faker::Currency.code }
    asset_source { AssetSource.where(name: FactoryBot.build(:asset_source).name).first_or_create! }
    asset_type { AssetType.where(name: FactoryBot.build(:asset_type).name).first_or_create! }
  end
end
