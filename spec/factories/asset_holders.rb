# frozen_string_literal: true

FactoryBot.define do
  factory :asset_holder do
    name do
      ['Bank', 'Revolut', 'N26', 'Wise',
       'Broker', 'IBKR', 'Degiro', 'Trading212', 'eToro',
       'Crypto Exchange', 'Kraken', 'Coinbase', 'Binance',
       'Other'].sample
    end

    initialize_with do
      AssetHolder.find_or_create_by(name:)
    end
  end
end
