# frozen_string_literal: true

class CurrencyConverterService < ApplicationService
  attr_accessor :from, :to, :date, :amount, :fallback_to_past_rate

  def call
    cache_key = "exchange_rate_#{from.ticker}_#{to.ticker}_#{date}_#{fallback_to_past_rate}"

    exchange_rate = Rails.cache.fetch(cache_key) do
      direct_exchange.presence || intermediary_exchange.presence
    end

    amount * exchange_rate if exchange_rate.present?
  end

  private

  def direct_exchange
    find_exchange_rate(from:, to:)&.rate
  end

  def intermediary_exchange
    return if intermediary_exchange_rate.blank?

    intermediary_to_exchange_rate = find_exchange_rate(from: intermediary_exchange_rate.to, to:)
    intermediary_to_exchange_rate.rate * intermediary_exchange_rate.rate if intermediary_to_exchange_rate.present?
  end

  def scope
    date_query = fallback_to_past_rate ? 'date <= ?' : 'date >= ?'
    order = fallback_to_past_rate ? 'desc' : 'asc'
    ExchangeRate.includes(:from, :to).where(date_query, date).order(date: order)
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
