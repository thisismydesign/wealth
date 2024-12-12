# frozen_string_literal: true

class TotalBalancesService < ApplicationService
  attr_accessor :user

  def call
    asset_and_asset_holder_pairs.map do |asset_id, asset_holder_id|
      asset = Asset.includes(:sell_trades, :buy_trades, :fundings, :asset_type).find(asset_id)
      asset_holder = AssetHolder.find(asset_holder_id)

      balance = BalanceService.call(asset:, asset_holder:, user:)
      value = ValueService.call(amount: balance, asset:)
      funding = ValueService.call(amount: FundingService.call(asset:, asset_holder:, user:), asset:)

      { asset_holder:, asset:, balance:, value:, funding: }
    end
  end

  private

  def asset_and_asset_holder_pairs
    (trade_from_pairs + trade_to_pairs + funding_pairs + income_pairs).uniq
  end

  def trade_from_pairs
    trade_scope.select(:from_id, :asset_holder_id).distinct.pluck(:from_id, :asset_holder_id)
  end

  def trade_to_pairs
    trade_scope.select(:to_id, :asset_holder_id).distinct.pluck(:to_id, :asset_holder_id)
  end

  def funding_pairs
    funding_scope.select(:asset_id, :asset_holder_id).distinct.pluck(:asset_id, :asset_holder_id)
  end

  def income_pairs
    income_scope.select(:asset_id, :asset_holder_id).distinct.pluck(:asset_id, :asset_holder_id)
  end

  def trade_scope
    TradePolicy::Scope.new(user, Trade).resolve
  end

  def funding_scope
    FundingPolicy::Scope.new(user, Funding).resolve
  end

  def income_scope
    IncomePolicy::Scope.new(user, Income).resolve
  end
end
