# frozen_string_literal: true

class CreatePricesService < ApplicationService
  attr_accessor :priceable, :currency, :amount

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
    converted_amount = convert(to: Asset.tax_base)

    priceable.prices.create(asset: Asset.tax_base, amount: converted_amount)
  end

  def create_trade_base_price
    converted_amount = convert(to: Asset.trade_base, fallback_to_past_rate: true)

    priceable.prices.create(asset: Asset.trade_base, amount: converted_amount)
  end

  def convert(to:, fallback_to_past_rate: false)
    converted_amount = CurrencyConverterService.call(
      from: currency, to:, date: priceable.date, amount:, fallback_to_past_rate:
    )
    return converted_amount if converted_amount.present?

    entity = "#{priceable.class.name}##{priceable.id}"
    msg = "No conversion available from #{currency.ticker} to #{to.ticker} on #{entity}"
    raise ApplicationError, msg
  end
end
