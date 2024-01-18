# frozen_string_literal: true

class Price < ApplicationRecord
  belongs_to :asset
  belongs_to :priceable, polymorphic: true

  validates :amount, presence: true
  validate :check_priceable_type

  private

  def check_priceable_type
    return if %w[Trade Income].include?(priceable_type)

    errors.add(:priceable_type, 'must be either Trade or Income')
  end
end
