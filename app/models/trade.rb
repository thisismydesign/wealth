# frozen_string_literal: true

class Trade < ApplicationRecord
  belongs_to :from, class_name: 'Asset'
  belongs_to :to, class_name: 'Asset'
  belongs_to :asset_holder
  belongs_to :user

  has_many :prices, as: :priceable, class_name: 'Price', dependent: :destroy, inverse_of: :priceable
  has_one :tax_base_price, lambda {
                             where(asset: Asset.tax_base)
                           }, as: :priceable, class_name: 'Price', dependent: :destroy, inverse_of: :priceable
  has_one :trade_base_price, lambda {
                               where(asset: Asset.trade_base)
                             }, as: :priceable, class_name: 'Price', dependent: :destroy, inverse_of: :priceable

  has_many :open_trade_pairs, class_name: 'TradePair', foreign_key: 'close_trade_id', dependent: :destroy,
                              inverse_of: :close_trade
  has_many :close_trade_pairs, class_name: 'TradePair', foreign_key: 'open_trade_id', dependent: :destroy,
                               inverse_of: :open_trade

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

  scope :year_eq, lambda { |year|
                    where('date >= ?', DateTime.parse("#{year}.01.01").beginning_of_year)
                      .where('date <= ?', DateTime.parse("#{year}.01.01").end_of_year)
                  }
  scope :type_eq, ->(type) { public_send(type) }

  validates :date, :from_amount, :to_amount, presence: true

  after_save :create_prices
  # after_save :assign_trade_pairs

  def create_prices
    CreateTradePricesJob.perform_later(id)
  end

  # def assign_trade_pairs
  #   AssignTradePairsJob.perform_later(id)
  # end

  def self.ransackable_attributes(_auth_object = nil)
    %w[date from_amount to_amount from_id to_id asset_holder_id user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[from to asset_holder]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %w[year_eq type_eq]
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

  def type
    if to.currency? && !from.currency?
      :close
    elsif from.currency? && !to.currency?
      :open
    else
      :inter
    end
  end

  def open_trade_open_to_amount
    return if type != :open

    to_amount - close_trade_pairs.sum(&:amount)
  end

  def open_trade_status
    return if type != :open

    if open_trade_closed?
      :fully_closed
    elsif open_trade_open_to_amount == to_amount
      :fully_open
    else
      :partially_closed
    end
  end

  def open_trade_closed?
    open_trade_open_to_amount <= 0
  end
end
