# frozen_string_literal: true

class CalculateOpenPriceService < ApplicationService
  attr_accessor :close_trade

  def call
    return if close_trade.type != :close
    return if open_trade_tax_base_prices.any?(&:nil?)

    open_amount
  end

  private

  def open_trade_tax_base_prices
    close_trade.open_trade_pairs.map { |trade_pair| trade_pair.open_trade.tax_base_price }
  end

  def open_amount
    close_trade.open_trade_pairs.sum do |open_trade_pair|
      open_trade_pair.open_trade.tax_base_price.amount * closed_ratio(open_trade_pair)
    end
  end

  def closed_ratio(open_trade_pair)
    open_trade_pair.amount / open_trade_pair.open_trade.to_amount
  end
end
