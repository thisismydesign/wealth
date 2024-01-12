# frozen_string_literal: true

# Initial real data
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
  { name: 'MSCI INDIA ETF (Acc, USD, LSEETF, iShares, UCITS)', ticker: 'NDIA', asset_type: etf, asset_source: broker },
  { name: 'S&P 500 ETF (Acc, EUR, IBIS2, iShares, UCITS)', ticker: 'SXR8', asset_type: etf, asset_source: broker },

  { name: 'Bitcoin', ticker: 'BTC', asset_type: crypto, asset_source: crypto_exchange },
  { name: 'Ethereum', ticker: 'ETH', asset_type: crypto, asset_source: crypto_exchange },
  { name: 'Solana', ticker: 'SOL', asset_type: crypto, asset_source: crypto_exchange },
  { name: 'Dogecoin', ticker: 'DOGE', asset_type: crypto, asset_source: crypto_exchange }
].each do |asset|
  Asset.where(asset).first_or_create!
end

%w[Dividend Rental Mining Staking Interest Other].each do |name|
  IncomeType.where(name:).first_or_create!
end
