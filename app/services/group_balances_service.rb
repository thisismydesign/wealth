# frozen_string_literal: true

class GroupBalancesService < ApplicationService
  attr_accessor :asset_balances

  def call
    asset_balances.each_with_object({}) do |asset_balance, hash|
      group_by, key = yield(asset_balance)
      add(hash, asset_balance, group_by, key)
    end.values
  end

  private

  def add(hash, asset_balance, group_by, key)
    hash[key] ||= { group_by:, value: 0, balance: 0, funding: 0 }
    hash[key][:value] += asset_balance[:value]
    hash[key][:balance] += asset_balance[:balance]
    hash[key][:funding] += asset_balance[:funding]
  end
end
