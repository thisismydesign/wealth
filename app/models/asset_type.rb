# frozen_string_literal: true

class AssetType < ApplicationRecord
  has_many :assets, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.currency
    where(name: 'Currency').first_or_create!
  end

  def self.crypto
    where(name: 'Crypto').first_or_create!
  end

  def self.real_estate
    where(name: 'Real estate').first_or_create!
  end
end
