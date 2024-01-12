# frozen_string_literal: true

class ClosedPositionsService < ApplicationService
  attr_accessor :year

  def call
    scope = Trade.includes(:from, :open_trade_pairs, to: :asset_type).where(asset_type: { name: 'Currency' })
    scope = scope.where('extract(year from date) = ?', year) if year.present?

    scope
  end
end
