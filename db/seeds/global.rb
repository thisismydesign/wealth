# frozen_string_literal: true

# Initial real data
%w[Crypto Currency Stablecoin].each do |asset_type|
  AssetType.where(name: asset_type).first_or_create!
end

%w[Mining Staking Lending Interest Other].each do |name|
  IncomeType.where(name:).first_or_create!
end

[
  'Kraken', 'Coinbase', 'Binance', 'Crypto Exchange', 'Other'
].each do |asset_holder|
  AssetHolder.where(name: asset_holder).first_or_create!
end

currency = AssetType.find_by(name: 'Currency')
crypto = AssetType.find_by(name: 'Crypto')
stablecoin = AssetType.find_by(name: 'Stablecoin')
# etf = AssetType.find_by(name: 'ETF')

[
  { ticker: 'EUR', name: 'Euro', asset_type: currency },
  { ticker: 'USD', name: 'US Dollar', asset_type: currency },
  { ticker: 'HUF', name: 'Hungarian Forint', asset_type: currency },

  # { ticker: 'LON:VUSD', name: 'Vanguard S&P 500 USD Dist', description: 'Dist, USD, LSEETF, Vanguard, UCITS',
  #   asset_type: etf },
  # { ticker: 'AMS:VUSA', name: 'Vanguard S&P 500 EUR Dist', description: 'Dist, EUR, AEB, Vanguard, UCITS',
  #   asset_type: etf },
  # { ticker: 'LON:NDIA', name: 'iShares MSCI INDIA USD Acc', description: 'Acc, USD, LSEETF, iShares, UCITS',
  #   asset_type: etf },
  # { ticker: 'FRA:CSPX', name: 'iShares S&P 500 EUR Acc', description: 'Acc, EUR, IBIS2, iShares, UCITS, aka SXR8',
  #   asset_type: etf },

  { ticker: 'BTC', name: 'Bitcoin', asset_type: crypto },
  { ticker: 'ETH', name: 'Ethereum', asset_type: crypto },
  { ticker: 'SOL', name: 'Solana', asset_type: crypto },
  { ticker: 'DOGE', name: 'Dogecoin', asset_type: crypto },
  { ticker: 'USDT', name: 'Tether', asset_type: stablecoin },
  { ticker: 'USDC', name: 'USDC', asset_type: stablecoin }
].each do |asset|
  Asset.find_or_create_by!(
    ticker: asset[:ticker], asset_type: asset[:asset_type], name: asset[:name]
  )
end
