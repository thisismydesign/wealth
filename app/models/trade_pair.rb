# frozen_string_literal: true

class TradePair < ApplicationRecord
  belongs_to :open_trade, class_name: 'Trade'
  belongs_to :close_trade, class_name: 'Trade'

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount]
  end
end
