# frozen_string_literal: true

class TotalIncomeService < ApplicationService
  attr_accessor :year

  def call
    scope = Income.includes(:tax_base_price)
    scope = scope.where('extract(year from date) = ?', year) if year.present?

    scope.sum { |income| income.tax_base_price&.amount || 0 }
  end
end
