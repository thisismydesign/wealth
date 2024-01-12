# frozen_string_literal: true

class Income < ApplicationRecord
  belongs_to :income_type
  belongs_to :asset
  belongs_to :source, class_name: 'Asset', optional: true

  validates :amount, presence: true
  validates :date, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount date income_type_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[income_type]
  end
end
