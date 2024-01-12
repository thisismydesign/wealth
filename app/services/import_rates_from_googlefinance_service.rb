# frozen_string_literal: true

class ImportRatesFromGooglefinanceService < ApplicationService
  def call
    rates.each do |rate|
      response = GooglefinanceService.call(sheet: rate[:sheet])
      CSV.parse(response.body, headers: true) do |row|
        ExchangeRate.where(from: rate[:from], to: rate[:to], date: row['Date'], rate: row['Close']).first_or_create!
      end
    end
  end

  private

  def rates
    [
      {
        from: Asset.find_by(ticker: 'SXR8'),
        to: Asset.find_by(ticker: 'EUR'),
        sheet: 'AMS:CSPX'
      },
      {
        from: Asset.find_by(ticker: 'BTC'),
        to: Asset.find_by(ticker: 'EUR'),
        sheet: 'BTCEUR'
      },
      {
        from: Asset.find_by(ticker: 'ETH'),
        to: Asset.find_by(ticker: 'EUR'),
        sheet: 'ETHEUR'
      },
      {
        from: Asset.find_by(ticker: 'VUSD'),
        to: Asset.find_by(ticker: 'USD'),
        sheet: 'LON:VUSD'
      },
      {
        from: Asset.find_by(ticker: 'VUSA'),
        to: Asset.find_by(ticker: 'EUR'),
        sheet: 'AMS:VUSA'
      },
      {
        from: Asset.find_by(ticker: 'NDIA'),
        to: Asset.find_by(ticker: 'USD'),
        sheet: 'AMS:NDIA'
      },
      {
        from: Asset.find_by(ticker: 'USD'),
        to: Asset.find_by(ticker: 'EUR'),
        sheet: 'USDEUR'
      }
    ]
  end
end
