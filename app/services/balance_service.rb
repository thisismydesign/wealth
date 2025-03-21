# frozen_string_literal: true

class BalanceService < ApplicationService
  attr_accessor :asset, :year, :asset_holder, :user

  def call
    balance = FundingService.call(asset:, year:, asset_holder:, user:)

    balance -= total_from_trades
    balance += total_to_trades
    balance += total_incomes

    balance
  end

  private

  def total_from_trades
    scope = trade_scope.where(from: asset)
    scope = scope.year_eq(year) if year.present?
    scope = scope.where(asset_holder:) if asset_holder.present?

    scope.sum(:from_amount)
  end

  def total_to_trades
    scope = trade_scope.where(to: asset, user:)
    scope = scope.year_eq(year) if year.present?
    scope = scope.where(asset_holder:) if asset_holder.present?

    scope.sum(:to_amount)
  end

  def total_incomes
    scope = income_scope.where(asset:)
    scope = scope.year_eq(year) if year.present?
    scope = scope.where(asset_holder:) if asset_holder.present?

    scope.sum(:amount)
  end

  def trade_scope
    TradePolicy::Scope.new(user, Trade).resolve
  end

  def income_scope
    IncomePolicy::Scope.new(user, Income).resolve
  end
end
