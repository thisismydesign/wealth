# frozen_string_literal: true

class IncomeType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :incomes, dependent: :restrict_with_error

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[incomes]
  end

  def self.dividend
    where(name: 'Dividend').first_or_create!
  end

  def self.staking
    where(name: 'Staking').first_or_create!
  end

  def self.interest
    where(name: 'Interest').first_or_create!
  end

  def self.work
    where(name: 'Work').first_or_create!
  end
end
