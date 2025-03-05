# frozen_string_literal: true

class Funding < ApplicationRecord
  belongs_to :asset
  belongs_to :asset_holder
  belongs_to :user

  validates :amount, presence: true
  validates :date, presence: true

  scope :year_eq, lambda { |year|
                    where('date >= ?', DateTime.parse("#{year}.01.01").beginning_of_year)
                      .where('date <= ?', DateTime.parse("#{year}.01.01").end_of_year)
                  }

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount date asset_holder_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[asset_holder]
  end

  def self.ransackable_scopes(_auth_object = nil)
    %w[year_eq]
  end
end
