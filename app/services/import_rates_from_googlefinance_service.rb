# frozen_string_literal: true

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
    @eur ||= EnsureAssetService.call(ticker: 'EUR', asset_type: AssetType.currency)
  end

  def usd
    @usd ||= EnsureAssetService.call(ticker: 'USD', asset_type: AssetType.currency)
  end

  # rubocop:disable Metrics/AbcSize
  def asset_pairs
    @asset_pairs ||= [
      { sheet: 'AMS:CSPX', to: eur, from: EnsureAssetService.call(ticker: 'FRA:CSPX', asset_type: AssetType.etf) },
      { sheet: 'LON:VUSD', to: usd, from: EnsureAssetService.call(ticker: 'LON:VUSD', asset_type: AssetType.etf) },
      { sheet: 'AMS:VUSA', to: eur, from: EnsureAssetService.call(ticker: 'AMS:VUSA', asset_type: AssetType.etf) },
      { sheet: 'LON:NDIA', to: usd, from: EnsureAssetService.call(ticker: 'LON:NDIA', asset_type: AssetType.etf) },
      { sheet: 'BTCEUR', to: eur, from: EnsureAssetService.call(ticker: 'BTC', asset_type: AssetType.crypto) },
      { sheet: 'ETHEUR', to: eur, from: EnsureAssetService.call(ticker: 'ETH', asset_type: AssetType.crypto) },
      { sheet: 'USDEUR', to: eur, from: usd }
    ]
  end
  # rubocop:enable Metrics/AbcSize
end
