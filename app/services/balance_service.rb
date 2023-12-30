# frozen_string_literal: true

class BalanceService < ApplicationService
  attr_accessor :asset_id

  def call
    balance = total_deposits

    balance -= total_from_trades
    balance += total_to_trades

    balance
  end

  private

  def asset
    @asset ||= Asset.find(asset_id)
  end

  def total_deposits
    Deposit.where(asset_id: asset.id).sum(:amount)
  end

  def total_from_trades
    Trade.where(from_id: asset.id).sum(:from_amount)
  end

  def total_to_trades
    Trade.where(to_id: asset.id).sum(:to_amount)
  end
end
