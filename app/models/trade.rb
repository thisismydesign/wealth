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
    if to.currency?
      :close
    elsif from.currency?
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
