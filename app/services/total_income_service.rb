# frozen_string_literal: true

class TotalIncomeService < ApplicationService
  attr_accessor :year

  def call
    asset_ids = Income.distinct.pluck(:asset_id)

    asset_ids.sum do |asset_id|
      asset = Asset.find(asset_id)
      scope = Income.where(asset_id:)
      incomes = scope.where('extract(year from date) = ?', year) if year.present?

      incomes.sum do |income|
        CurrencyConverterService.call(from: asset, to: TaxCurrencyService.call, date: income.date,
                                      amount: income.amount)
      end
    end
  end
end
