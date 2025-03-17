# frozen_string_literal: true

class CreateTradePricesService < ApplicationService
  attr_accessor :trade

  def call
    return if inter_trade?

    CreatePricesService.call(priceable: trade, currency: fiat_based_currency, amount: fiat_based_amount)
  end

  private

  def fiat_based_currency
    open_trade? ? trade.from : trade.to
  end

  def fiat_based_amount
    open_trade? ? trade.from_amount : trade.to_amount
  end

  def open_trade?
    trade.type == :open
  end

  def inter_trade?
    trade.type == :inter
  end
end
