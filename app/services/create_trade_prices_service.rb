# frozen_string_literal: true

class CreateTradePricesService < ApplicationService
  attr_accessor :trade

  def call
    return if trade.type_inter?

    CreatePricesService.call(priceable: trade, original_currency:, original_amount:)
  end

  private

  def original_currency
    trade.type_open? ? trade.from : trade.to
  end

  def original_amount
    trade.type_open? ? trade.from_amount : trade.to_amount
  end
end
