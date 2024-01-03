# frozen_string_literal: true

class AssetSource < ApplicationRecord
  has_many :assets, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.bank
    where(name: 'Bank').first_or_create!
  end
end
