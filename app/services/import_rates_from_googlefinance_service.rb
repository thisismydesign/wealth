# frozen_string_literal: true

require 'csv'

class ImportRatesFromGooglefinanceService < ApplicationService
  def call
    asset_pairs.each do |rate|
      response = GooglefinanceService.call(sheet: rate[:sheet])
      CSV.parse(response.body, headers: true) do |row|
        exchange_rate = ExchangeRate.where(from: rate[:from], to: rate[:to], date: row['Date']).first_or_initialize
        exchange_rate.rate = row['Close']
        exchange_rate.save!
      end
    end
  end

  def eur
    @eur ||= EnsureAssetService.call(name: 'EUR', type: AssetType.currency)
  end

  def usd
    @usd ||= EnsureAssetService.call(name: 'USD', type: AssetType.currency)
  end

  # rubocop:disable Metrics/AbcSize
  def asset_pairs
    @asset_pairs ||= [
      { sheet: 'AMS:CSPX', to: eur, from: EnsureAssetService.call(name: 'FRA:CSPX', type: AssetType.etf) },
      { sheet: 'LON:VUSD', to: usd, from: EnsureAssetService.call(name: 'LON:VUSD', type: AssetType.etf) },
      { sheet: 'AMS:VUSA', to: eur, from: EnsureAssetService.call(name: 'AMS:VUSA', type: AssetType.etf) },
      { sheet: 'LON:NDIA', to: usd, from: EnsureAssetService.call(name: 'LON:NDIA', type: AssetType.etf) },
      { sheet: 'BTCEUR', to: eur, from: EnsureAssetService.call(name: 'BTC', type: AssetType.crypto) },
      { sheet: 'ETHEUR', to: eur, from: EnsureAssetService.call(name: 'ETH', type: AssetType.crypto) },
      { sheet: 'USDEUR', to: eur, from: usd }
    ]
  end
  # rubocop:enable Metrics/AbcSize
end
