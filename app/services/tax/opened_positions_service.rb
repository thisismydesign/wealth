# frozen_string_literal: true

module Tax
  class OpenedPositionsService < ApplicationService
    attr_accessor :user, :year, :to_asset_type

    def call
      scope = trade_scope.open_trades

      scope = scope.year_eq(year) if year.present?
      scope = scope.where(asset_types: { name: to_asset_type.name }) if to_asset_type.present?

      scope.includes(
        :tax_base_price,
        to: :asset_type,
        from: :asset_type
      )
    end

    private

    def trade_scope
      TradePolicy::Scope.new(user, Trade).resolve
    end
  end
end
