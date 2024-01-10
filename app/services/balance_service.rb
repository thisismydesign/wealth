# frozen_string_literal: true

class BalanceService < ApplicationService
  attr_accessor :asset_id, :year

  def call
    balance = DepositService.call(asset_id:, year:)

    balance -= total_from_trades
    balance += total_to_trades

    balance
  end

  private

  def total_from_trades
    scope = Trade.where(from_id: asset_id)
    scope = scope.where('extract(year from date) <= ?', year) if year.present?

    scope.sum(:from_amount)
  end

  def total_to_trades
    scope = Trade.where(to_id: asset_id)
    scope = scope.where('extract(year from date) <= ?', year) if year.present?

    scope.sum(:to_amount)
  end
end
