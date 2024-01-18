# frozen_string_literal: true

FactoryBot.define do
  factory :asset_type do
    name { ['Currency', 'Stock', 'ETF', 'Crypto', 'Real estate', 'Other'].sample }

    initialize_with do
      AssetType.find_or_create_by(name:)
    end
  end
end
