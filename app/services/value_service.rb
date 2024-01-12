# frozen_string_literal: true

class ValueService < ApplicationService
  attr_accessor :asset_id, :amount, :date

  def call
    return 0 if amount.zero?
    return amount if asset == trade_base_asset

    CurrencyConverterService.call(from: asset, to: trade_base_asset, date: date || Time.zone.today, amount:,
                                  past_available: true)
  end

  private

  def asset
    @asset ||= Asset.find(asset_id)
  end

  def trade_base_asset
    @trade_base_asset ||= Asset.find_by(ticker: Rails.application.config.x.trade_base_currency)
  end
end
