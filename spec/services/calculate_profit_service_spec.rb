# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateProfitService do
  subject(:call) { described_class.call(close_trade:, currency: eur) }

  let(:eur) { create(:asset, ticker: 'EUR', asset_type: AssetType.currency) }
  let(:btc) { create(:asset, ticker: 'BTC', asset_type: AssetType.crypto) }
  let(:close_trade) { create(:trade, from_amount: 1, to_amount: 40_000, from: btc, to: eur) }

  before do
    create(:trade, from_amount: 35_000, to_amount: 1, from: eur, to: btc, date: 1.day.ago)
    create(:exchange_rate, from: eur, to: eur, date: 1.day.ago, rate: 1)
    create(:exchange_rate, from: eur, to: eur, date: Time.zone.today, rate: 1)
  end

  it 'returns the profit in the given currency' do
    expect(call).to eq(5000)
  end
end
