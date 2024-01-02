# frozen_string_literal: true

class RoundService < ApplicationService
  attr_accessor :decimal

  def call
    return 0 if decimal.zero?
    raise "only BigDecimal is accepted (given: #{decimal} which is #{decimal.class})" unless decimal.is_a?(BigDecimal)

    round
  end

  private

  def round
    if large_number_or_whole?
      decimal.round
    elsif decimal.abs >= 1
      decimal.round(leading_zeros + 1)
    else
      decimal.round(leading_zeros + 2)
    end
  end

  def leading_zeros
    decimal.exponent.abs
  end

  def large_number_or_whole?
    decimal.abs >= 10 || decimal.frac.zero?
  end
end
