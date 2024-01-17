# frozen_string_literal: true

class AssignTradePairsJob < ApplicationJob
  def perform(trade_id)
    AssignFifoOpenTradePairsService.call(close_trade_id: trade_id)
  end
end
