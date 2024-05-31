# frozen_string_literal: true

# Initial real data
['Currency', 'Stock', 'ETF', 'Crypto', 'Real estate', 'Other'].each do |asset_type|
  AssetType.where(name: asset_type).first_or_create!
end

%w[Dividend Rental Mining Staking Interest Other].each do |name|
  IncomeType.where(name:).first_or_create!
end

[
  'Bank', 'Revolut', 'N26', 'Wise',
  'Broker', 'IBKR', 'Degiro', 'Trading212', 'eToro',
  'Crypto Exchange', 'Kraken', 'Coinbase', 'Binance',
  'Other'
].each do |asset_holder|
  AssetHolder.where(name: asset_holder).first_or_create!
end

currency = AssetType.find_by(name: 'Currency')
crypto = AssetType.find_by(name: 'Crypto')
etf = AssetType.find_by(name: 'ETF')

[
  { ticker: 'EUR', name: 'Euro', asset_type: currency },
  { ticker: 'USD', name: 'US Dollar', asset_type: currency },
  { ticker: 'HUF', name: 'Hungarian Forint', asset_type: currency },

  { ticker: 'VUSD', name: 'Vanguard S&P 500 USD Dist', description: 'Dist, USD, LSEETF, Vanguard, UCITS',
    asset_type: etf },
  { ticker: 'VUSA', name: 'Vanguard S&P 500 EUR Dist', description: 'Dist, EUR, AEB, Vanguard, UCITS',
    asset_type: etf },
  { ticker: 'NDIA', name: 'iShares MSCI INDIA USD Acc', description: 'Acc, USD, LSEETF, iShares, UCITS',
    asset_type: etf },
  { ticker: 'CSPX', name: 'iShares S&P 500 EUR Acc', description: 'Acc, EUR, IBIS2, iShares, UCITS, aka SXR8',
    asset_type: etf },

  { ticker: 'BTC', name: 'Bitcoin', asset_type: crypto },
  { ticker: 'ETH', name: 'Ethereum', asset_type: crypto },
  { ticker: 'SOL', name: 'Solana', asset_type: crypto },
  { ticker: 'DOGE', name: 'Dogecoin', asset_type: crypto }
].each do |asset|
  Asset.find_or_create_by!(
    ticker: asset[:ticker], asset_type: asset[:asset_type]
  ).update!(asset.except(:ticker, :asset_type))
end
