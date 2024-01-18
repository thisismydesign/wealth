# frozen_string_literal: true

class OpenPositionsService < ApplicationService
  attr_accessor :year

  def call
    scope.group_by(&:to).map do |to_asset, trades_by_to|
      trades_by_to.group_by(&:from).map do |from_asset, trades|
        to_amount = trades.sum(&:to_amount)
        from_amount = trades.sum(&:from_amount)

        Trade.new(to: to_asset, from: from_asset, to_amount:, from_amount:)
      end.flatten
    end.flatten
  end

  private

  def scope
    scope = Trade.includes(:to, :close_trade_pairs, from: :asset_type).where(asset_type: { name: 'Currency' })
    scope = scope.where('extract(year from date) <= ?', year) if year.present?

    scope.filter { |trade| !trade.open_trade_closed? }
  end
end
