# frozen_string_literal: true

class CurrencyConverterService < ApplicationService
  attr_accessor :from, :to, :date, :amount

  # C/mon rubocop, this is not too complex
  # rubocop:disable Metrics/AbcSize
  def call
    exchange_rate = ExchangeRate.where(from:, to:).where('date >= ?', date).order(date: :asc).first

    return amount * exchange_rate.rate if exchange_rate.present?

    opposite_exchange_rate = ExchangeRate.where(from: to, to: from).where('date >= ?', date).order(date: :asc).first
    return 0 if opposite_exchange_rate.present? && opposite_exchange_rate.rate.zero?

    amount / opposite_exchange_rate.rate if opposite_exchange_rate.present?
  end
  # rubocop:enable Metrics/AbcSize
end
