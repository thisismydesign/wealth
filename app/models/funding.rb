# frozen_string_literal: true

class Funding < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_holder
  belongs_to :user

  validates :amount, presence: true
  validates :date, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount asset_holder_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[asset_holder]
  end
end
