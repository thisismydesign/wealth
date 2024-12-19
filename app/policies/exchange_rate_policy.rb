# frozen_string_literal: true

class ExchangeRatePolicy < AdminPolicy
  def create?
    false
  end

  def update?
    false
  end
end
