# frozen_string_literal: true

module Tax
  class ClosedPositionsService < ApplicationService
    attr_accessor :user, :year, :from_asset_type

    def call
      scope = trade_scope.close_trades

      scope = scope.where('extract(year from date) = ?', year) if year.present?
      scope = scope.where(from_asset_types: { name: from_asset_type.name }) if from_asset_type.present?

      scope.includes(
        :tax_base_price,
        to: :asset_type,
        from: :asset_type,
        open_trade_pairs: { open_trade: :tax_base_price }
      )
    end

    private

    def trade_scope
      TradePolicy::Scope.new(user, Trade).resolve
    end
  end
end
