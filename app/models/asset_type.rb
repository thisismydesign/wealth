# frozen_string_literal: true

class AssetType < ApplicationRecord
  has_many :assets, dependent: :restrict_with_exception

  def self.ransackable_associations(_auth_object = nil)
    %w[assets]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
