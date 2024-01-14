# frozen_string_literal: true

class TradePrice < ApplicationRecord
  belongs_to :asset
  belongs_to :trade

  validates :amount, presence: true
end
