# frozen_string_literal: true

class TotalBalancesService < ApplicationService
  attr_accessor :year

  def call
    balances = Asset.includes(:sell_trades, :buy_trades, :deposits).find_each.map do |asset|
      {
        asset:,
        balance: BalanceService.call(asset_id: asset.id, year:)
      }
    end

    balances.filter { |asset_balance| asset_balance[:balance].positive? }
  end
end
