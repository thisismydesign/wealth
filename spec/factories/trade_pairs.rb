# frozen_string_literal: true

FactoryBot.define do
  factory :trade_pair do
    open_trade { association(:trade) }
    closed_trade_id { association(:trade) }
  end
end
