# frozen_string_literal: true

class TaxCurrencyService < ApplicationService
  @tax_currency = nil

  def call
    @call ||= Asset.where(
      ticker: Rails.application.config.x.tax_base_currency
    ).first_or_create!(name: Rails.application.config.x.tax_base_currency, asset_type: AssetType.currency)
  end
end
