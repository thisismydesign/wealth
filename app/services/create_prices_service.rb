# frozen_string_literal: true

class CreatePricesService < ApplicationService
  attr_accessor :priceable, :traded_currency, :traded_amount

  def call
    remove_prices

    create_tax_base_price
    create_trade_base_price
  end

  private

  def remove_prices
    priceable.prices.destroy_all
  end

  def create_tax_base_price
    amount = convert(to: Asset.tax_base)

    priceable.prices.create(asset: Asset.tax_base, amount:)
  end

  def create_trade_base_price
    amount = convert(to: Asset.trade_base, fallback_to_past_rate: true)

    priceable.prices.create(asset: Asset.trade_base, amount:)
  end

  def convert(to:, fallback_to_past_rate: false)
    amount = CurrencyConverterService.call(
      from: traded_currency, to:, date: priceable.date, amount: traded_amount, fallback_to_past_rate:
    )
    return amount if amount.present?

    entity = "#{priceable.class.name}##{priceable.id}"
    msg = "No conversion available from #{traded_currency.ticker} to #{to.ticker} on #{entity}"
    raise ApplicationError, msg
  end
end
