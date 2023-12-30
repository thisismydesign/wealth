# frozen_string_literal: true

class Trade < ApplicationRecord
  belongs_to :from, class_name: 'Asset'
  belongs_to :to, class_name: 'Asset'

  def self.ransackable_attributes(_auth_object = nil)
    %w[date from_amount to_amount]
  end

  def humanized
    "#{from_amount} #{from.ticker_or_name} -> #{to_amount} #{to.ticker_or_name}"
  end
end
