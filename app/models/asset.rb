# frozen_string_literal: true

class Asset < ApplicationRecord
  belongs_to :user, optional: true
  has_many :sell_trades, inverse_of: :from, foreign_key: 'from_id', class_name: 'Trade',
                         dependent: :restrict_with_exception

  has_many :buy_trades, inverse_of: :to, foreign_key: 'to_id', class_name: 'Trade', dependent: :restrict_with_exception
  has_many :fundings, dependent: :restrict_with_exception
  has_many :incomes, dependent: :restrict_with_exception
  has_many :prices, dependent: :restrict_with_exception
  belongs_to :asset_type
  has_many :exchange_rates_from, class_name: 'ExchangeRate', foreign_key: 'from_id', dependent: :destroy,
                                 inverse_of: :from
  has_many :exchange_rates_to, class_name: 'ExchangeRate', foreign_key: 'to_id', dependent: :destroy, inverse_of: :to

  validates :ticker, presence: true, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :name, presence: true
  validate :prevent_personal_duplicate_of_global
  validate :ticker_uppercase

  def self.ransackable_attributes(_auth_object = nil)
    %w[name ticker description]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end

  def self.tax_base
    where(
      ticker: Rails.application.config.x.tax_base_currency
    ).first_or_create!(name: Rails.application.config.x.tax_base_currency, asset_type: AssetType.currency)
  end

  def self.trade_base
    where(
      ticker: Rails.application.config.x.trade_base_currency
    ).first_or_create!(name: Rails.application.config.x.trade_base_currency, asset_type: AssetType.currency)
  end

  def currency?
    asset_type.name == 'Currency'
  end

  def stablecoin?
    asset_type.name == 'Stablecoin'
  end

  def crypto?
    asset_type.name == 'Crypto'
  end

  private

  def prevent_personal_duplicate_of_global
    return if user_id.blank?

    return unless Asset.exists?(ticker:, user_id: nil)

    errors.add(:ticker, I18n.t('asset.validation_errors.personal_duplicate_of_global'))
  end

  def ticker_uppercase
    return if ticker == ticker&.upcase

    errors.add(:ticker, I18n.t('asset.validation_errors.ticker_uppercase'))
  end
end
