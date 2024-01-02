# frozen_string_literal: true

class TaxCurrencyService < ApplicationService
  def call
    Asset.where(ticker: Rails.application.config.x.tax_base_currency,
                asset_type: AssetType.currency,
                asset_source: AssetSource.bank,
                name: 'Hungarian Forint').first_or_create!
  end
end
