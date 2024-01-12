# frozen_string_literal: true

class CurrencyConverterService < ApplicationService
  attr_accessor :from, :to, :date, :amount

  def call
    return direct_exchange if direct_exchange.present?

    intermediary_exchange.presence
  end

  private

  def direct_exchange
    @direct_exchange ||= begin
      exchange_rate = find_exchange_rate(from:, to:)
      amount * exchange_rate.rate if exchange_rate.present?
    end
  end

  def intermediary_exchange
    @intermediary_exchange ||= if intermediary_exchange_rate.present?
                                 exchange_rate = find_exchange_rate(from: intermediary_exchange_rate.to, to:)
                                 amount * exchange_rate.rate * intermediary_exchange_rate.rate if exchange_rate.present?
                               end
  end

  def scope
    ExchangeRate.includes(:from, :to).where('date >= ?', date).order(date: :asc)
  end

  def find_exchange_rate(from:, to:)
    exchange_rate = scope.where(from:, to:).first

    return exchange_rate if exchange_rate.present?

    opposite_exchange_rate = scope.where(from: to, to: from).first
    return if opposite_exchange_rate.blank?
    return opposite_exchange_rate if opposite_exchange_rate.rate.zero?

    opposite_exchange_rate.rate = 1 / opposite_exchange_rate.rate
    opposite_exchange_rate
  end

  def intermediary_exchange_rate
    find_exchange_rate(from:, to: { asset_type: AssetType.currency })
  end
end
