# frozen_string_literal: true

class Asset < ApplicationRecord
  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
