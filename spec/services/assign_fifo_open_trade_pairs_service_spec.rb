# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssignFifoOpenTradePairsService do
  subject(:call) { described_class.call(close_trade_id: close_trade.id) }

  let(:eur) { create(:asset, ticker: 'EUR', asset_type: AssetType.currency) }
  let(:btc) { create(:asset, ticker: 'BTC', asset_type: AssetType.crypto) }
  let(:close_trade) { create(:trade, from_amount: 1, to_amount: 40_000, from: btc, to: eur) }

  context 'when there is an open trade with equal amount' do
    let!(:open_trade) { create(:trade, from_amount: 40_000, to_amount: 1, from: eur, to: btc, date: 1.day.ago) }

    it 'creates a trade pair with the open trade and the close trade' do
      expect { call }.to change(TradePair, :count).by(1)
    end

    it 'assigns a trade pair with the open trade and the close trade' do
      call

      expect(close_trade.reload.open_trade_pairs.last).to have_attributes(open_trade:, close_trade:,
                                                                          amount: 1)
    end
  end

  context 'when there are multiple open trades with amount equal to close trade' do
    before do
      create(:trade, from_amount: 20_000, to_amount: 0.5, from: eur, to: btc, date: 1.day.ago)
      create(:trade, from_amount: 20_000, to_amount: 0.5, from: eur, to: btc, date: 2.days.ago)
    end

    it 'creates trade pairs for all trades' do
      expect { call }.to change(TradePair, :count).by(2)
    end

    it 'assigns a trade pair with the open trade and the close trade' do
      expect(close_trade.open_trade_pairs).to all(
        have_attributes(close_trade:, amount: 0.5)
      )
    end
  end

  context 'when there are multiple open trades with amount more than the close trade' do
    before do
      create(:trade, from_amount: 20_000, to_amount: 0.5, from: eur, to: btc, date: 2.days.ago)
      create(:trade, from_amount: 20_000, to_amount: 0.5, from: eur, to: btc, date: 3.days.ago)
    end

    let!(:not_closed_open_trade) do
      create(:trade, from_amount: 20_000, to_amount: 0.5, from: eur, to: btc, date: 1.day.ago)
    end

    it 'creates trade pairs for amount of trades that fill the close order' do
      expect { call }.to change(TradePair, :count).by(2)
    end

    it 'does not assign trade pairs to remaining most recent open trade' do
      call

      expect(not_closed_open_trade.close_trade_pairs).to be_empty
    end
  end

  context 'when there are multiple open trades with fractional amount more than the close trade' do
    before do
      create(:trade, from_amount: 20_000, to_amount: 0.4, from: eur, to: btc, date: 2.days.ago)
      create(:trade, from_amount: 20_000, to_amount: 0.4, from: eur, to: btc, date: 3.days.ago)
    end

    let!(:fractional_open_trade) do
      create(:trade, from_amount: 20_000, to_amount: 0.5, from: eur, to: btc, date: 1.day.ago)
    end

    it 'creates trade pairs for all trades' do
      expect { call }.to change(TradePair, :count).by(3)
    end

    it 'assigns trade pair of fractional amount to remaining most recent open trade' do
      call

      expect(fractional_open_trade.close_trade_pairs.last.amount).to eq(0.2)
    end
  end

  context 'when trade is already closed' do
    before do
      open_trade = create(:trade, from_amount: 40_000, from: eur, to_amount: 1, to: btc, date: 1.day.ago)
      create(:trade_pair, open_trade:, close_trade:, amount: 1)
    end

    it 'does not create a trade pair' do
      expect { call }.not_to change(TradePair, :count)
    end
  end
end
