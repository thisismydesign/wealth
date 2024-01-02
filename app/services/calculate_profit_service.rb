# frozen_string_literal: true

class CalculateProfitService < ApplicationService
  attr_accessor :close_trade, :currency

  def call
    AssignFifoOpenTradePairsService.call(close_trade_id: close_trade.id)

    close_amount - open_amount
  end

  def open_amount
    close_trade.open_trade_pairs.sum do |open_trade_pair|
      open_trade = open_trade_pair.open_trade

      CurrencyConverterService.call(from: open_trade.from, to: currency,
                                    date: open_trade.date, amount: closed_amount(open_trade_pair))
    end
  end

  def close_amount
    CurrencyConverterService.call(from: close_trade.to, to: currency, date: close_trade.date,
                                  amount: close_trade.to_amount)
  end

  def closed_amount(open_trade_pair)
    open_trade = open_trade_pair.open_trade
    open_trade.from_amount / open_trade.to_amount * open_trade_pair.amount
  end
end
