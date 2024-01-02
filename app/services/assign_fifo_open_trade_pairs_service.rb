# frozen_string_literal: true

class AssignFifoOpenTradePairsService < ApplicationService
  attr_accessor :close_trade_id

  def call
    return if close_trade.open_trade_pairs.sum(&:amount) >= close_trade.from_amount

    amount_closed = BigDecimal('0')

    open_trades.each do |open_trade|
      break if trade_closed?(amount_closed)

      trade_pair = create_trade_pair(amount_closed, open_trade)

      amount_closed += trade_pair.amount
    end
  end

  private

  def create_trade_pair(amount_closed, open_trade)
    if fully_closes_open_trade?(amount_closed, open_trade)
      TradePair.where(open_trade:, close_trade:, amount: open_trade.open_amount).first_or_create!
    else
      TradePair.where(open_trade:, close_trade:,
                      amount: close_trade.from_amount - amount_closed).first_or_create!
    end
  end

  def close_trade
    @close_trade ||= Trade.find(close_trade_id)
  end

  def open_trades
    Trade.where(from: close_trade.to, to: close_trade.from)
         .where('date <= ?', close_trade.date)
         .order(:date)
  end

  def fully_closes_open_trade?(amount_closed, open_trade)
    close_trade.from_amount >= amount_closed + open_trade.to_amount
  end

  def trade_closed?(amount_closed)
    amount_closed >= close_trade.from_amount
  end
end
