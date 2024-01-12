# frozen_string_literal: true

class TotalIncomeService < ApplicationService
  attr_accessor :year

  def call
    asset_ids = Income.distinct.pluck(:asset_id)

    asset_ids.sum do |asset_id|
      scope = Income.where(asset_id:)
      scope = scope.where('extract(year from date) = ?', year) if year.present?

      scope.sum do |income|
        CurrencyConverterService.call(from: Asset.find(asset_id), to: TaxCurrencyService.call, date: income.date,
                                      amount: income.amount) || 0
      end
    end
  end
end
