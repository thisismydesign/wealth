# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrencyConverterService do
  subject(:call) { described_class.call(from:, to:, date: Time.zone.today, amount:) }

  let(:from) { create(:asset) }
  let(:to) { create(:asset) }
  let(:amount) { BigDecimal('10') }
  let(:rate) { BigDecimal('2') }

  it 'returns nil when exchange rate is not found' do
    expect(call).to be_nil
  end

  context 'when exchange rate is found' do
    before { create(:exchange_rate, from:, to:, rate:) }

    it 'returns the converted amount' do
      expect(call).to eq(20)
    end
  end

  context 'when exchange rate is found but in opposite direction' do
    before { create(:exchange_rate, from: to, to: from, rate:) }

    it 'returns the converted amount' do
      expect(call).to eq(5)
    end
  end

  context 'when exchange rate is found but in opposite direction and rate is 0' do
    before { create(:exchange_rate, from: to, to: from, rate: 0) }

    it 'returns 0' do
      expect(call).to eq(0)
    end
  end

  context 'when exchange rate is not present for the given day but is present for a later day' do
    before { create(:exchange_rate, from:, to:, rate: 3, date: 1.day.from_now) }

    it 'returns the converted amount' do
      expect(call).to eq(30)
    end
  end

  context 'when exchange rate is not present for the given day but is present for an earlier day' do
    before { create(:exchange_rate, from:, to:, rate: 3, date: 1.day.ago) }

    it 'returns nil' do
      expect(call).to be_nil
    end

    context 'with past_available set to true' do
      subject(:call) { described_class.call(from:, to:, date: Time.zone.today, amount:, past_available: true) }

      it 'returns the converted amount' do
        expect(call).to eq(30)
      end
    end
  end

  context 'when direct exchange rate between pairs is not present but is present through another currency' do
    let(:intermediary_asset) { create(:asset, asset_type: AssetType.currency) }

    before do
      create(:exchange_rate, from:, to: intermediary_asset, rate: 3)
      create(:exchange_rate, from: intermediary_asset, to:, rate: 2)
    end

    it 'returns the converted amount' do
      expect(call).to eq(amount * 6)
    end
  end
end
