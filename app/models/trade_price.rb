# frozen_string_literal: true

class TradePrice < ApplicationRecord
  belongs_to :asset
  belongs_to :trade

  validates :amount, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount]
  end
end
