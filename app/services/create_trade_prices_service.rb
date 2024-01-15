# frozen_string_literal: true

class CreateTradePricesService < ApplicationService
  attr_accessor :trade

  def call
    return if inter_trade?

    remove_trade_prices

    create_tax_base_price
    create_trade_base_price
  end

  private

  def remove_trade_prices
    trade.trade_prices.destroy_all
  end

  def create_tax_base_price
    amount = convert(to: Asset.tax_base)

    trade.trade_prices.create(asset: Asset.tax_base, amount:)
  end

  def create_trade_base_price
    amount = convert(to: Asset.trade_base, fallback_to_past_rate: true)

    trade.trade_prices.create(asset: Asset.trade_base, amount:)
  end

  def convert(to:, fallback_to_past_rate: false)
    amount = CurrencyConverterService.call(
      from: traded_currency, to:, date: trade.date, amount: traded_currency_amount, fallback_to_past_rate:
    )
    return amount if amount.present?

    raise ApplicationError,
          "No conversion available from #{traded_currency.ticker} to #{to.ticker} on Trade##{trade.id}"
  end

  def traded_currency
    open_trade? ? trade.from : trade.to
  end

  def traded_currency_amount
    open_trade? ? trade.from_amount : trade.to_amount
  end

  def open_trade?
    trade.type == :open
  end

  def inter_trade?
    trade.type == :inter
  end
end
