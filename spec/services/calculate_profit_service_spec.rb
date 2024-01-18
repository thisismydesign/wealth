# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalculateProfitService do
  subject(:call) { described_class.call(close_trade:) }

  let(:currency) { Asset.tax_base }
  let(:btc) { create(:asset, ticker: 'BTC', asset_type: AssetType.crypto) }
  let(:close_trade) { create(:trade, from_amount: 1, from: btc, to_amount: 40_000, to: currency) }
  let(:open_trade) { create(:trade, from_amount: 20_000, to_amount: 1, from: currency, to: btc, date: 1.day.ago) }

  context 'when tax base price is present for close and open trades' do
    context 'when there is an single open trade' do
      before do
        create(:price, priceable: close_trade, asset: currency, amount: 1000)
        create(:price, priceable: open_trade, asset: currency, amount: 100)
        create(:trade_pair, open_trade:, close_trade:, amount: 1)
      end

      it 'returns the difference' do
        expect(call).to eq(900)
      end
    end

    context 'when there are multiple open trades' do
      before do
        create_list(:trade, 2, from_amount: 10_000, to_amount: 0.5, from: currency, to: btc,
                               date: 1.day.ago).each do |multi_open_trade|
          create(:trade_pair, open_trade: multi_open_trade, close_trade:, amount: 0.5)
          create(:price, priceable: multi_open_trade, asset: currency, amount: 100)
        end
        create(:price, priceable: close_trade, asset: currency, amount: 1000)
      end

      it 'returns the difference' do
        expect(call).to eq(800)
      end
    end

    context 'when open trade partially closes close trade' do
      let(:open_trade) { create(:trade, from_amount: 20_000, to_amount: 2, from: currency, to: btc, date: 1.day.ago) }

      before do
        create(:price, priceable: close_trade, asset: currency, amount: 1000)
        create(:price, priceable: open_trade, asset: currency, amount: 100)
        create(:trade_pair, open_trade:, close_trade:, amount: 1)
      end

      it 'returns the difference' do
        expect(call).to eq(950)
      end
    end
  end

  context 'when trade pair is missing' do
    it 'returns nil' do
      expect(call).to be_nil
    end
  end

  context 'when tax base price is missing for open trade' do
    before do
      create(:trade_pair, open_trade:, close_trade:, amount: 1)
      create(:price, priceable: close_trade, asset: currency, amount: 1000)
    end

    it 'returns nil' do
      expect(call).to be_nil
    end
  end

  context 'when tax base price is missing for close trade' do
    before do
      create(:trade_pair, open_trade:, close_trade:, amount: 1)
      create(:price, priceable: open_trade, asset: currency, amount: 1000)
    end

    it 'returns nil' do
      expect(call).to be_nil
    end
  end
end
