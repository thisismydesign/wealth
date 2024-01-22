# frozen_string_literal: true

class TotalBalancesService < ApplicationService
  attr_accessor :year

  def call
    balances = asset_and_asset_holder_pairs.map do |asset_id, asset_holder_id|
      asset = Asset.includes(:sell_trades, :buy_trades, :fundings, :asset_type).find(asset_id)
      asset_holder = AssetHolder.find(asset_holder_id)

      balance = BalanceService.call(asset:, asset_holder:, year:)
      value = ValueService.call(amount: balance, asset:, date:)
      funding = FundingService.call(asset:, asset_holder:, year:)

      { asset_holder:, asset:, balance:, value:, funding: }
    end

    balances.filter { |asset_balance| asset_balance[:balance].positive? }
  end

  private

  def date
    year ? Date.new(year, 12, 31) : nil
  end

  def asset_and_asset_holder_pairs
    trade_from_pairs = Trade.select(:from_id, :asset_holder_id).distinct.pluck(:from_id, :asset_holder_id)
    trade_to_pairs = Trade.select(:to_id, :asset_holder_id).distinct.pluck(:to_id, :asset_holder_id)
    funding_pairs = Funding.select(:asset_id, :asset_holder_id).distinct.pluck(:asset_id, :asset_holder_id)
    income_pairs = Income.select(:asset_id, :asset_holder_id).distinct.pluck(:asset_id, :asset_holder_id)

    (trade_from_pairs + trade_to_pairs + funding_pairs + income_pairs).uniq
  end
end
