# frozen_string_literal: true

class RoundService < ApplicationService
  attr_accessor :decimal

  def call
    raise 'only BigDecimal is accepted' unless decimal.is_a?(BigDecimal)

    if large_number_or_whole?
      decimal.round
    elsif decimal >= 1
      decimal.round(leading_zeros + 1)
    else
      decimal.round(leading_zeros + 2)
    end
  end

  private

  def leading_zeros
    decimal.exponent.abs
  end

  def large_number_or_whole?
    decimal >= 10 || decimal.frac.zero?
  end
end
