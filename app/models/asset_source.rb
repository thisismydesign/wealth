# frozen_string_literal: true

class AssetSource < ApplicationRecord
  has_many :assets, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
