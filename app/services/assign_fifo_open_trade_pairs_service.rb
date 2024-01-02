# frozen_string_literal: true

class AssignFifoOpenTradePairsService < ApplicationService
  attr_accessor :close_trade

  def call
    closed_amount = BigDecimal('0')

    open_trades.each do |open_trade|
      if close_trade.from_amount >= closed_amount + open_trade.to_amount
        TradePair.where(open_trade:, close_trade:, amount: open_trade.to_amount).first_or_create!

        closed_amount += open_trade.to_amount
      end

      break if closed_amount >= close_trade.to_amount
    end
  end

  private

  def open_trades
    Trade.where(from: close_trade.to, to: close_trade.from)
         .where('date <= ?', close_trade.date)
         .order(:date)
  end
end
