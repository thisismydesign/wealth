# frozen_string_literal: true

class ClosedPositionsService < ApplicationService
  attr_accessor :year

  def call
    scope = Trade.close_trades.includes(
      :tax_base_trade_price,
      to: :asset_type,
      from: :asset_type,
      open_trade_pairs: { open_trade: :tax_base_trade_price }
    )
    scope = scope.where('extract(year from date) = ?', year) if year.present?

    scope
  end
end
