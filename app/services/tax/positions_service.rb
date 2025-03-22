# frozen_string_literal: true

module Tax
  class PositionsService < ApplicationService
    attr_accessor :user, :year, :trade_type

    def call
      scope = trade_scope
      scope = scope.where(trade_type:) if trade_type.present?
      scope = scope.year_eq(year) if year.present?

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
