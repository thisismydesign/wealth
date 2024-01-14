# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trade do
  subject(:trade) { build(:trade, from_amount: 40_000, from:, to_amount: 1, to:) }

  let(:from) { build(:asset, name: 'Euro', ticker: 'EUR') }
  let(:to) { build(:asset, name: 'Bitcoin', ticker: 'BTC') }

  it { is_expected.to belong_to(:asset_holder) }

  describe '#humanized' do
    it 'returns a humanized version of the trade' do
      expect(trade.humanized).to eq('40000 EUR -> 1 BTC')
    end
  end

  describe '#type' do
    context 'when from is a currency' do
      let(:from) { build(:asset, asset_type: AssetType.currency) }

      it 'returns :open' do
        expect(trade.type).to eq(:open)
      end
    end

    context 'when to is a currency' do
      let(:to) { build(:asset, asset_type: AssetType.currency) }

      it 'returns :close' do
        expect(trade.type).to eq(:close)
      end
    end

    context 'when neither from nor to is a currency' do
      let(:from) { build(:asset, asset_type: AssetType.crypto) }
      let(:to) { build(:asset, asset_type: AssetType.crypto) }

      it 'returns :inter' do
        expect(trade.type).to eq(:inter)
      end
    end

    context 'when both from and to are currencies' do
      let(:from) { build(:asset, asset_type: AssetType.currency) }
      let(:to) { build(:asset, asset_type: AssetType.currency) }

      it 'returns :inter' do
        expect(trade.type).to eq(:inter)
      end
    end
  end
end
