# frozen_string_literal: true

class IncomeType < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
