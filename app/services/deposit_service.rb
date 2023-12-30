# frozen_string_literal: true

class DepositService < ApplicationService
  attr_accessor :asset_id, :year

  def call
    scope = Deposit.where(asset_id:)
    scope = scope.where('extract(year from date) = ?', year) if year.present?

    scope.sum(:amount)
  end
end
