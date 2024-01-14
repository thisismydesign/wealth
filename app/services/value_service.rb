# frozen_string_literal: true

class ValueService < ApplicationService
  attr_accessor :asset, :amount, :date

  def call
    return 0 if amount.zero?
    return amount if asset == trade_base_asset

    CurrencyConverterService.call(
      from: asset, to: trade_base_asset, date: date || Time.zone.today,
      amount:, fallback_to_past_rate: true
    ) || purchase_value
  end

  private

  def trade_base_asset
    @trade_base_asset ||= Asset.find_by(ticker: Asset.trade_base)
  end

  def purchase_value
    Trade.where(to: asset).sum do |trade|
      CurrencyConverterService.call(
        from: trade.from, to: trade_base_asset, date: date || Time.zone.today,
        amount: trade.from_amount, fallback_to_past_rate: true
      )
    end
  end
end
