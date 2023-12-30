# frozen_string_literal: true

FactoryBot.define do
  factory :asset_type do
    name { ['Currency', 'Stock', 'ETF', 'Crypto', 'Real estate', 'Other'].sample }
  end
end
