# frozen_string_literal: true

FactoryBot.define do
  factory :asset_source do
    name do
      [
        'Bank', 'Revolut', 'N26', 'Wise',
        'Broker', 'IBKR', 'Degiro', 'Trading212', 'eToro',
        'Crypto Exchange', 'Kraken', 'Coinbase', 'Binance',
        'Other'
      ].sample
    end
  end
end
