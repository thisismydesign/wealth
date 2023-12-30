# frozen_string_literal: true

class Asset < ApplicationRecord
  has_many :sell_trades, inverse_of: :from, foreign_key: 'from_id', class_name: 'Trade',
                         dependent: :restrict_with_exception

  has_many :buy_trades, inverse_of: :to, foreign_key: 'to_id', class_name: 'Trade', dependent: :restrict_with_exception
  has_many :deposits, dependent: :restrict_with_exception
  belongs_to :asset_type
  belongs_to :asset_source

  validates :name,
            uniqueness: { scope: %i[asset_type_id asset_source_id],
                          message: I18n.t('models.asset.validations.uniqueness') }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name ticker description]
  end

  def ticker_or_name
    ticker || name
  end
end
