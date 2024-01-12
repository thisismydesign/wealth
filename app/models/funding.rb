# frozen_string_literal: true

class Funding < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_holder

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount]
  end
end
