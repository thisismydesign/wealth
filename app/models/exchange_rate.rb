# frozen_string_literal: true

class ExchangeRate < ApplicationRecord
  belongs_to :from, class_name: 'Asset'
  belongs_to :to, class_name: 'Asset'

  validates :date, uniqueness: { scope: %i[from_id to_id], message: I18n.t('models.asset.exchange_rate.uniqueness') }

  def self.ransackable_attributes(_auth_object = nil)
    %w[amount]
  end
end
