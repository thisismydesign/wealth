# frozen_string_literal: true

class TotalIncomeService < ApplicationService
  attr_accessor :year

  def call
    scope = Income.includes(:asset)
    scope = scope.where('extract(year from date) = ?', year) if year.present?

    scope.sum do |income|
      CurrencyConverterService.call(
        from: income.asset, to: TaxCurrencyService.call, date: income.date, amount: income.amount
      ) || 0
    end
  end
end
