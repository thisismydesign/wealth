# frozen_string_literal: true

class AssetType < ApplicationRecord
  has_many :assets, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  @currency = nil
  def self.currency
    @currency ||= where(name: 'Currency').first_or_create!
  end

  @crypto = nil
  def self.crypto
    @crypto ||= where(name: 'Crypto').first_or_create!
  end
end
