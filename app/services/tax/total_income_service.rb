# frozen_string_literal: true

module Tax
  class TotalIncomeService < ApplicationService
    attr_accessor :user, :year, :income_type

    def call
      scope = income_scope.includes(:tax_base_price)
      scope = scope.where(income_type_id: income_type.id) if income_type.present?
      scope = scope.where('extract(year from date) = ?', year) if year.present?

      scope.sum { |income| income.tax_base_price&.amount || 0 }
    end

    private

    def income_scope
      IncomePolicy::Scope.new(user, Income).resolve
    end
  end
end
