# frozen_string_literal: true

[
  { name: 'Euro', ticker: 'EUR', is_currency: true },
  { name: 'US Dollar', ticker: 'USD', is_currency: true },
  { name: 'Hungarian Forint', ticker: 'HUF', is_currency: true },

  { name: 'S&P 500 ETF (Dist, USD, LSEETF, Vanguard, UCITS)', ticker: 'VUSD' },
  { name: 'S&P 500 ETF (Dist, EUR, AEB, Vanguard, UCITS)', ticker: 'VUSA' },
  { name: 'MSCI INDIA ETF (Acc, USD, LSEETF, iShares, UCITS)', ticker: 'VUSA' },

  { name: 'Bitcoin', ticker: 'BTC' },
  { name: 'Ethereum', ticker: 'ETH' },
  { name: 'Solana', ticker: 'SOL' },
  { name: 'Dogecoin', ticker: 'DOGE' }
].each do |currency|
  Asset.where(currency).first_or_create!
end

Trade.create!(date: 1.week.ago, from_amount: 40_000, from: Asset.find_by(ticker: 'EUR'), to_amount: 1.258,
              to: Asset.find_by(ticker: 'BTC'))
Trade.create!(date: 1.day.ago, from_amount: 1, from: Asset.find_by(ticker: 'BTC'), to_amount: 45_000,
              to: Asset.find_by(ticker: 'EUR'))
