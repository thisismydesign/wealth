# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateTradePricesJob do
  subject(:perform_now) { described_class.perform_now(trade.id) }

  let(:trade) { create(:trade) }

  before do
    allow(CreateTradePricesService).to receive(:call)
  end

  it 'calls CreateTradePricesService' do
    perform_now

    expect(CreateTradePricesService).to have_received(:call).with(trade:)
  end
end
