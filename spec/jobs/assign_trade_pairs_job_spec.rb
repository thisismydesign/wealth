# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignTradePairsJob do
  subject(:perform_now) { described_class.perform_now(trade.id) }

  let(:trade) { create(:trade) }

  before do
    allow(AssignFifoOpenTradePairsService).to receive(:call)
  end

  it 'calls AssignFifoOpenTradePairsService' do
    perform_now

    expect(AssignFifoOpenTradePairsService).to have_received(:call).with(close_trade_id: trade.id)
  end
end
