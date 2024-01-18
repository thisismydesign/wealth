# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trade do
  subject(:trade) { build(:trade, from_amount: 40_000, from:, to_amount: 1, to:) }

  let(:from) { build(:asset, name: 'Euro', ticker: 'EUR') }
  let(:to) { build(:asset, name: 'Bitcoin', ticker: 'BTC') }

  it { is_expected.to belong_to(:asset_holder) }
  it { is_expected.to belong_to(:from).class_name('Asset') }
  it { is_expected.to belong_to(:to).class_name('Asset') }

  it { is_expected.to have_one(:trade_base_price).dependent(:destroy) }
  it { is_expected.to have_one(:tax_base_price).dependent(:destroy) }

  describe '#humanized' do
    it 'returns a humanized version of the trade' do
      expect(trade.humanized).to eq('40000 EUR -> 1 BTC')
    end
  end

  describe '#type' do
    context 'when from is a currency and to is not' do
      let(:to) { build(:asset, asset_type: AssetType.crypto) }
      let(:from) { build(:asset, asset_type: AssetType.currency) }

      it 'returns :open' do
        expect(trade.type).to eq(:open)
      end
    end

    context 'when to is a currency and from is not' do
      let(:to) { build(:asset, asset_type: AssetType.currency) }
      let(:from) { build(:asset, asset_type: AssetType.crypto) }

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

  describe '.close_trades' do
    subject(:close_trades) { described_class.close_trades }

    let!(:trade) { create(:trade, from_amount: 40_000, from:, to_amount: 1, to:) }

    context 'when to is a currency and from is not' do
      let(:to) { build(:asset, asset_type: AssetType.currency) }
      let(:from) { build(:asset, asset_type: AssetType.crypto) }

      it 'is included' do
        expect(close_trades).to include(trade)
      end
    end

    context 'when from is a currency and to is not' do
      let(:to) { build(:asset, asset_type: AssetType.crypto) }
      let(:from) { build(:asset, asset_type: AssetType.currency) }

      it 'is not included' do
        expect(close_trades).not_to include(trade)
      end
    end

    context 'when both to and from are not currencies' do
      let(:to) { build(:asset, asset_type: AssetType.crypto) }
      let(:from) { build(:asset, asset_type: AssetType.crypto) }

      it 'is not included' do
        expect(close_trades).not_to include(trade)
      end
    end

    context 'when both to and from are currencies' do
      let(:to) { build(:asset, asset_type: AssetType.currency) }
      let(:from) { build(:asset, asset_type: AssetType.currency) }

      it 'is not included' do
        expect(close_trades).not_to include(trade)
      end
    end
  end

  describe '.open_trades' do
    subject(:open_trades) { described_class.open_trades }

    let!(:trade) { create(:trade, from_amount: 40_000, from:, to_amount: 1, to:) }

    context 'when to is a currency and from is not' do
      let(:to) { build(:asset, asset_type: AssetType.currency) }
      let(:from) { build(:asset, asset_type: AssetType.crypto) }

      it 'is not included' do
        expect(open_trades).not_to include(trade)
      end
    end

    context 'when from is a currency and to is not' do
      let(:to) { build(:asset, asset_type: AssetType.crypto) }
      let(:from) { build(:asset, asset_type: AssetType.currency) }

      it 'is included' do
        expect(open_trades).to include(trade)
      end
    end

    context 'when both to and from are not currencies' do
      let(:to) { build(:asset, asset_type: AssetType.crypto) }
      let(:from) { build(:asset, asset_type: AssetType.crypto) }

      it 'is not included' do
        expect(open_trades).not_to include(trade)
      end
    end

    context 'when both to and from are currencies' do
      let(:to) { build(:asset, asset_type: AssetType.currency) }
      let(:from) { build(:asset, asset_type: AssetType.currency) }

      it 'is not included' do
        expect(open_trades).not_to include(trade)
      end
    end
  end
end
