# frozen_string_literal: true

class TotalBalancesService < ApplicationService
  attr_accessor :year

  def call
    balances = Asset.includes(:sell_trades, :buy_trades, :fundings, :asset_type).find_each.map do |asset|
      balance = BalanceService.call(asset:, year:)

      {
        asset:,
        balance:,
        value: ValueService.call(amount: balance, asset:, date:)
      }
    end

    balances.filter { |asset_balance| asset_balance[:balance].positive? }
  end

  private

  def date
    year ? Date.new(year, 12, 31) : nil
  end
end
