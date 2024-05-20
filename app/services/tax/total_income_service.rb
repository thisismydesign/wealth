# frozen_string_literal: true

module Tax
  class TotalIncomeService < ApplicationService
    attr_accessor :year, :income_type

    def call
      scope = Income.includes(:tax_base_price)
      scope = scope.where(income_type_id: income_type.id) if income_type.present?
      scope = scope.where('extract(year from date) = ?', year) if year.present?

      scope.sum { |income| income.tax_base_price&.amount || 0 }
    end
  end
end
