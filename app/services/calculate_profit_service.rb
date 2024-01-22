# frozen_string_literal: true

class CalculateProfitService < ApplicationService
  attr_accessor :close_trade

  def call
    return if close_trade.type != :close
    return if open_trade_tax_base_prices.any?(&:nil?)
    return if close_trade.tax_base_price.nil?

    close_amount - CalculateOpenPriceService.call(close_trade:)
  end

  private

  def close_amount
    close_trade.tax_base_price.amount
  end

  def open_trade_tax_base_prices
    close_trade.open_trade_pairs.map { |trade_pair| trade_pair.open_trade.tax_base_price }
  end
end
