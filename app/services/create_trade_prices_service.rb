# frozen_string_literal: true

class CreateTradePricesService < ApplicationService
  attr_accessor :trade

  def call
    return if inter_trade?

    CreatePricesService.call(priceable: trade, original_currency:, original_amount:)
  end

  private

  def original_currency
    open_trade? ? trade.from : trade.to
  end

  def original_amount
    open_trade? ? trade.from_amount : trade.to_amount
  end

  def open_trade?
    trade.type == :open
  end

  def inter_trade?
    trade.type == :inter
  end
end
