# frozen_string_literal: true

['Currency', 'Stock', 'ETF', 'Crypto', 'Real estate', 'Other'].each do |asset_type|
  AssetType.where(name: asset_type).first_or_create!
end

[
  'Bank', 'Revolut', 'N26', 'Wise',
  'Broker', 'IBKR', 'Degiro', 'Trading212', 'eToro',
  'Crypto Exchange', 'Kraken', 'Coinbase', 'Binance',
  'Other'
].each do |asset_source|
  AssetSource.where(name: asset_source).first_or_create!
end

currency = AssetType.find_by(name: 'Currency')
crypto = AssetType.find_by(name: 'Crypto')
bank = AssetSource.find_by(name: 'Bank')
crypto_exchange = AssetSource.find_by(name: 'Crypto Exchange')
broker = AssetSource.find_by(name: 'Broker')
etf = AssetType.find_by(name: 'ETF')

[
  { name: 'Euro', ticker: 'EUR', asset_type: currency, asset_source: bank },
  { name: 'US Dollar', ticker: 'USD', asset_type: currency, asset_source: bank },
  { name: 'Hungarian Forint', ticker: 'HUF', asset_type: currency, asset_source: bank },

  { name: 'S&P 500 ETF (Dist, USD, LSEETF, Vanguard, UCITS)', ticker: 'VUSD', asset_type: etf, asset_source: broker },
  { name: 'S&P 500 ETF (Dist, EUR, AEB, Vanguard, UCITS)', ticker: 'VUSA', asset_type: etf, asset_source: broker },
  { name: 'MSCI INDIA ETF (Acc, USD, LSEETF, iShares, UCITS)', ticker: 'VUSA', asset_type: etf, asset_source: broker },

  { name: 'Bitcoin', ticker: 'BTC', asset_type: crypto, asset_source: crypto_exchange },
  { name: 'Ethereum', ticker: 'ETH', asset_type: crypto, asset_source: crypto_exchange },
  { name: 'Solana', ticker: 'SOL', asset_type: crypto, asset_source: crypto_exchange },
  { name: 'Dogecoin', ticker: 'DOGE', asset_type: crypto, asset_source: crypto_exchange }
].each do |asset|
  Asset.where(asset).first_or_create!
end

ExchangeRate.create!(date: 1.month.ago, from: Asset.find_by(ticker: 'EUR'), to: Asset.find_by(ticker: 'USD'), rate: 1.2)

Deposit.create!(date: 1.month.ago, amount: 100_000, asset: Asset.find_by(ticker: 'EUR'))

Trade.create!(date: 1.week.ago, from_amount: 40_000, from: Asset.find_by(ticker: 'EUR'), to_amount: 1.258,
              to: Asset.find_by(ticker: 'BTC'))
Trade.create!(date: 1.day.ago, from_amount: 1, from: Asset.find_by(ticker: 'BTC'), to_amount: 45_000,
              to: Asset.find_by(ticker: 'EUR'))
