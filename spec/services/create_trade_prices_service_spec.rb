# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateTradePricesService do
  subject(:call) { described_class.call(trade:) }

  let(:amount) { BigDecimal('10') }
  let!(:currency) { create(:asset, asset_type: AssetType.currency) }

  context 'when trade is :inter' do
    let(:trade) { create(:trade, from: currency, to: currency) }

    it 'does not create trade prices' do
      expect { call }.not_to change(TradePrice, :count)
    end
  end

  context 'when trade is :open' do
    let(:crypto) { create(:asset, asset_type: AssetType.crypto) }
    let(:trade) { create(:trade, from: currency, to: crypto, from_amount: amount) }

    context 'when conversion is available' do
      before do
        allow(CurrencyConverterService).to receive(:call).and_return(0.1)
      end

      it 'creates trade prices' do
        expect { call }.to change(TradePrice, :count).by(2)
      end

      it 'creates trade prices with correct amounts' do
        call

        expect(trade.trade_prices.map(&:amount)).to contain_exactly(0.1, 0.1)
      end
    end

    context 'when conversion is not available' do
      it 'raises an error' do
        expect { call }.to raise_error(ApplicationError)
      end
    end
  end
end
