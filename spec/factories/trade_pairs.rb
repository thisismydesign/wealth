# frozen_string_literal: true

FactoryBot.define do
  factory :trade_pair do
    open_trade { association(:trade) }
    close_trade { association(:trade) }
  end
end
