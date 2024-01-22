# frozen_string_literal: true

class BalanceService < ApplicationService
  attr_accessor :asset, :year, :asset_holder

  def call
    balance = FundingService.call(asset:, year:, asset_holder:)

    balance -= total_from_trades
    balance += total_to_trades

    balance
  end

  private

  def total_from_trades
    scope = Trade.where(from: asset)
    scope = scope.where('extract(year from date) <= ?', year) if year.present?
    scope = scope.where(asset_holder:) if asset_holder.present?

    scope.sum(:from_amount)
  end

  def total_to_trades
    scope = Trade.where(to: asset)
    scope = scope.where('extract(year from date) <= ?', year) if year.present?
    scope = scope.where(asset_holder:) if asset_holder.present?

    scope.sum(:to_amount)
  end
end
