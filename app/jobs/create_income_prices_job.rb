# frozen_string_literal: true

class CreateIncomePricesJob < ApplicationJob
  def perform(income_id)
    income = Income.find(income_id)
    original_currency = income.asset
    original_amount = income.amount

    CreatePricesService.call(priceable: income, original_currency:, original_amount:)
  end
end
