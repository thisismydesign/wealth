# frozen_string_literal: true

class Trade < ApplicationRecord
  belongs_to :from, class_name: 'Asset'
  belongs_to :to, class_name: 'Asset'
  belongs_to :asset_holder
  has_many :open_trade_pairs, class_name: 'TradePair', foreign_key: 'close_trade_id', dependent: :destroy,
                              inverse_of: :close_trade
  has_many :close_trade_pairs, class_name: 'TradePair', foreign_key: 'open_trade_id', dependent: :destroy,
                               inverse_of: :open_trade
  has_many :trade_prices, dependent: :destroy

  scope :close_trades, lambda {
    joins(to: :asset_type)
      .joins('LEFT JOIN assets from_assets ON from_assets.id = trades.from_id')
      .joins('LEFT JOIN asset_types from_asset_types ON from_asset_types.id = from_assets.asset_type_id')
      .where(asset_types: { name: 'Currency' })
      .where.not(from_asset_types: { name: 'Currency' })
  }

  scope :open_trades, lambda {
    joins(to: :asset_type)
      .joins('LEFT JOIN assets from_assets ON from_assets.id = trades.from_id')
      .joins('LEFT JOIN asset_types from_asset_types ON from_asset_types.id = from_assets.asset_type_id')
      .where.not(asset_types: { name: 'Currency' })
      .where(from_asset_types: { name: 'Currency' })
  }


  def self.ransackable_attributes(_auth_object = nil)
    %w[date from_amount to_amount from_id to_id asset_holder_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[from to asset_holder]
  end

  def humanized
    "#{from_humanized} -> #{to_humanized}"
  end

  def from_humanized
    "#{RoundService.call(decimal: from_amount)} #{from.ticker}"
  end

  def to_humanized
    "#{RoundService.call(decimal: to_amount)} #{to.ticker}"
  end

  def to_price_in(currency)
    @to_price_in ||= CurrencyConverterService.call(from: to, to: currency, date:, amount: to_amount)
  end

  def type
    if to.currency? && !from.currency?
      :close
    elsif from.currency? && !to.currency?
      :open
    else
      :inter
    end
  end

  def open_amount
    @open_amount ||= to_amount - close_trade_pairs.sum(&:amount)
  end

  def closed
    return '' if type == :close

    if closed?
      'Yes'
    elsif open_amount == to_amount
      'No'
    else
      'Partially'
    end
  end

  def closed?
    open_amount <= 0
  end
end
