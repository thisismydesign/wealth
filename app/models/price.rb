# frozen_string_literal: true

class Price < ApplicationRecord
  belongs_to :asset
  belongs_to :priceable, polymorphic: true

  validates :amount, presence: true
  validate :check_priceable_type
  validate :asset_must_be_tax_base_or_trade_base

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount]
  end

  def humanized
    "#{RoundService.call(decimal: amount)} #{asset.ticker}"
  end

  private

  def check_priceable_type
    return if %w[Trade Income].include?(priceable_type)

    errors.add(:priceable_type, 'must be either Trade or Income')
  end

  def asset_must_be_tax_base_or_trade_base
    return if [Asset.tax_base, Asset.trade_base].include?(asset)

    errors.add(:asset, 'must be either Asset.tax_base or Asset.trade_base')
  end
end
