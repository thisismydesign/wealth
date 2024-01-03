# frozen_string_literal: true

class IncomeType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :incomes, dependent: :restrict_with_error

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
