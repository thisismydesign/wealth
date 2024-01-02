# frozen_string_literal: true

class TotalTaxesService < ApplicationService
  attr_accessor :close_trades

  def call
    (trades_sum || 0) * Rails.application.config.x.tax_rate.to_d
  end

  def trades_sum
    close_trades.sum do |trade|
      CurrencyConverterService.call(from: trade.to, to: tax_currency, date: trade.date, amount: trade.to_amount)
    end
  end

  def tax_currency
    @tax_currency ||= Asset.find_by(ticker: Rails.application.config.x.tax_base_currency,
                                    asset_type: AssetType.currency)
  end
end
