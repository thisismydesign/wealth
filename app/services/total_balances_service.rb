# frozen_string_literal: true

class TotalBalancesService < ApplicationService
  def call
    balances = Asset.includes(:sell_trades, :buy_trades, :deposits).find_each.map do |asset|
      {
        asset:,
        balance: BalanceService.call(asset_id: asset.id)
      }
    end

    balances.filter { |asset_balance| asset_balance[:balance].positive? }
  end
end
