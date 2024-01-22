# frozen_string_literal: true

class TotalBalancesService < ApplicationService
  def call
    asset_and_asset_holder_pairs.map do |asset_id, asset_holder_id|
      asset = Asset.includes(:sell_trades, :buy_trades, :fundings, :asset_type).find(asset_id)
      asset_holder = AssetHolder.find(asset_holder_id)

      balance = BalanceService.call(asset:, asset_holder:)
      value = ValueService.call(amount: balance, asset:)
      funding = ValueService.call(amount: FundingService.call(asset:, asset_holder:), asset:)

      { asset_holder:, asset:, balance:, value:, funding: }
    end
  end

  private

  def asset_and_asset_holder_pairs
    trade_from_pairs = Trade.select(:from_id, :asset_holder_id).distinct.pluck(:from_id, :asset_holder_id)
    trade_to_pairs = Trade.select(:to_id, :asset_holder_id).distinct.pluck(:to_id, :asset_holder_id)
    funding_pairs = Funding.select(:asset_id, :asset_holder_id).distinct.pluck(:asset_id, :asset_holder_id)
    income_pairs = Income.select(:asset_id, :asset_holder_id).distinct.pluck(:asset_id, :asset_holder_id)

    (trade_from_pairs + trade_to_pairs + funding_pairs + income_pairs).uniq
  end
end
