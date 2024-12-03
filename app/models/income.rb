# frozen_string_literal: true

class Income < ApplicationRecord
  belongs_to :income_type
  belongs_to :asset
  belongs_to :source, class_name: 'Asset', optional: true
  belongs_to :asset_holder
  belongs_to :user, optional: true

  has_many :prices, as: :priceable, class_name: 'Price', dependent: :destroy, inverse_of: :priceable
  has_one :tax_base_price, lambda {
                             where(asset: Asset.tax_base)
                           }, as: :priceable, class_name: 'Price', dependent: :destroy, inverse_of: :priceable
  has_one :trade_base_price, lambda {
                               where(asset: Asset.trade_base)
                             }, as: :priceable, class_name: 'Price', dependent: :destroy, inverse_of: :priceable

  validates :amount, presence: true
  validates :date, presence: true

  scope :year_eq, ->(year) { where('extract(year from date) = ?', year) }

  after_save :create_prices

  def create_prices
    CreateIncomePricesJob.perform_later(id)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount date income_type_id asset_holder_id source_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[income_type asset_holder source_id]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %w[year_eq]
  end
end
