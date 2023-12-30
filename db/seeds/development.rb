# frozen_string_literal: true

['EUR', 'USD', 'HUF'].each do |currency|
  Currency.where(name: currency).first_or_create!
end

['VUSD', 'VUSA', 'NDIA', 'AAPL', 'EUR', 'ETH', 'SOL', 'DOGE', 'Real estate'].each do |asset|
  Asset.where(name: asset).first_or_create!
end
