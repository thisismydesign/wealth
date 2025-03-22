# frozen_string_literal: true

class ImportJob < ApplicationJob
  def perform
    %w[EUR USD].each do |ticker|
      asset = EnsureAssetService.call(name: ticker, type: AssetType.currency)
      Import::ExchangeRateFromMnbService.call(asset:)
    end
    # ImportRatesFromGooglefinanceService.call
  end
end
