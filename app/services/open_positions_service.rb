# frozen_string_literal: true

class OpenPositionsService < ApplicationService
  attr_accessor :year

  def call
    scope.group_by(&:to).map do |to_asset, trades_by_to|
      trades_by_to.group_by(&:from).map do |from_asset, trades|
        create_sum_trade(to_asset, from_asset, trades)
      end.flatten
    end.flatten
  end

  private

  def scope
    scope = Trade.open_trades.includes(:to, :close_trade_pairs, :tax_base_price, :from)
    scope = scope.where('extract(year from date) <= ?', year) if year.present?

    scope.filter { |trade| !trade.open_trade_closed? }
  end

  def create_sum_trade(to_asset, from_asset, trades)
    to_amount = trades.sum(&:to_amount)
    from_amount = trades.sum(&:from_amount)
    tax_base_price = trades.sum { |trade| trade.tax_base_price&.amount || 0 }

    trade = Trade.new(to: to_asset, from: from_asset, to_amount:, from_amount:)
    trade.tax_base_price = Price.new(asset: Asset.tax_base, amount: tax_base_price)
    trade
  end
end
