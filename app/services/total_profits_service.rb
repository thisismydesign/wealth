# frozen_string_literal: true

class TotalProfitsService < ApplicationService
  attr_accessor :close_trades

  def call
    (trades_sum || 0) * Rails.application.config.x.tax_rate.to_d
  end

  def trades_sum
    close_trades.sum do |trade|
      CalculateProfitService.call(close_trade: trade, currency: Asset.tax_base)
    end
  end
end
