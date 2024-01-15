# frozen_string_literal: true

class TotalProfitsService < ApplicationService
  attr_accessor :close_trades

  def call
    close_trades.sum do |trade|
      CalculateProfitService.call(close_trade: trade) || 0
    end
  end
end
