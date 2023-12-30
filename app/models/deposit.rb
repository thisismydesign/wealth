# frozen_string_literal: true

class Deposit < ApplicationRecord
  belongs_to :asset

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount]
  end
end