# frozen_string_literal: true

class CreateTradePricesJob < ApplicationJob
  def perform(trade_id)
    CreateTradePricesService.call(trade: Trade.find(trade_id))
  end
end
