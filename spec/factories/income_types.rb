# frozen_string_literal: true

FactoryBot.define do
  factory :income_type do
    name { %w[Dividend Rental Mining Staking].sample }
  end
end
