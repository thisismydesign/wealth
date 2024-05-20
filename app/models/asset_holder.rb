# frozen_string_literal: true

class AssetHolder < ApplicationRecord
  has_many :trades, dependent: :restrict_with_exception
  has_many :fundings, dependent: :restrict_with_exception
  has_many :incomes, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.kraken
    where(name: 'Kraken').first_or_create!
  end

  def self.ibkr
    where(name: 'IBKR').first_or_create!
  end

  def self.binance
    where(name: 'Binance').first_or_create!
  end

  def self.wise
    where(name: 'Wise').first_or_create!
  end
end
