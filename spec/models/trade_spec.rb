# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trade do
  subject(:trade) { build(:trade, from_amount: 40_000, from:, to_amount: 1, to:) }

  let(:from) { build(:asset, name: 'Euro', ticker: 'EUR') }
  let(:to) { build(:asset, name: 'Bitcoin', ticker: 'BTC') }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:from_amount) }
    it { is_expected.to validate_presence_of(:to_amount) }

    it 'sets trade_type' do
      trade = build(:trade, trade_type: nil)
      trade.valid?

      expect(trade.trade_type).not_to be_nil
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:asset_holder) }
    it { is_expected.to belong_to(:from).class_name('Asset') }
    it { is_expected.to belong_to(:to).class_name('Asset') }
    it { is_expected.to belong_to(:user) }

    it { is_expected.to have_one(:trade_base_price).dependent(:destroy) }
    it { is_expected.to have_one(:tax_base_price).dependent(:destroy) }
  end

  describe '.year_eq' do
    it 'returns entity in given year' do
      entity = create(:trade, date: DateTime.now)

      expect(described_class.year_eq(Date.current.year)).to include(entity)
    end

    it 'does not return entity from earlier year' do
      entity = create(:trade, date: 1.year.ago)

      expect(described_class.year_eq(Date.current.year)).not_to include(entity)
    end

    it 'does not return entity from next year' do
      entity = create(:trade, date: 1.year.from_now)

      expect(described_class.year_eq(Date.current.year)).not_to include(entity)
    end
  end

  describe '#humanized' do
    it 'returns a humanized version of the trade' do
      expect(trade.humanized).to eq('40000 EUR -> 1 BTC')
    end
  end

  describe '#type' do
    # Trigger before_validation callback
    before { trade.valid? }

    context 'when from is a currency and to is not' do
      let(:to) { build(:asset, asset_type: AssetType.crypto) }
      let(:from) { build(:asset, asset_type: AssetType.currency) }

      it 'returns fiat_open' do
        expect(trade).to be_trade_type_fiat_open
      end
    end

    context 'when to is a currency and from is not' do
      let(:to) { build(:asset, asset_type: AssetType.currency) }
      let(:from) { build(:asset, asset_type: AssetType.crypto) }

      it 'returns fiat_close' do
        expect(trade).to be_trade_type_fiat_close
      end
    end

    context 'when neither from nor to is a currency' do
      let(:from) { build(:asset, asset_type: AssetType.crypto) }
      let(:to) { build(:asset, asset_type: AssetType.crypto) }

      it 'returns inter' do
        expect(trade).to be_trade_type_inter
      end
    end

    context 'when both from and to are currencies' do
      let(:from) { build(:asset, asset_type: AssetType.currency) }
      let(:to) { build(:asset, asset_type: AssetType.currency) }

      it 'returns inter' do
        expect(trade).to be_trade_type_inter
      end
    end

    context 'when from is a stablecoin and to is a crypto' do
      let(:from) { build(:asset, asset_type: AssetType.stablecoin) }
      let(:to) { build(:asset, asset_type: AssetType.crypto) }

      it 'returns crypto_open' do
        expect(trade).to be_trade_type_crypto_open
      end
    end

    context 'when from is a crypto and to is a stablecoin' do
      let(:from) { build(:asset, asset_type: AssetType.crypto) }
      let(:to) { build(:asset, asset_type: AssetType.stablecoin) }

      it 'returns crypto_close' do
        expect(trade).to be_trade_type_crypto_close
      end
    end

    context 'when both from and to are stablecoins' do
      let(:from) { build(:asset, asset_type: AssetType.stablecoin) }
      let(:to) { build(:asset, asset_type: AssetType.stablecoin) }

      it 'returns inter' do
        expect(trade).to be_trade_type_inter
      end
    end

    context 'when from is a stablecoin and to is a currency' do
      let(:from) { build(:asset, asset_type: AssetType.stablecoin) }
      let(:to) { build(:asset, asset_type: AssetType.currency) }

      it 'returns fiat_close' do
        expect(trade).to be_trade_type_fiat_close
      end
    end

    context 'when from is a currency and to is a stablecoin' do
      let(:from) { build(:asset, asset_type: AssetType.currency) }
      let(:to) { build(:asset, asset_type: AssetType.stablecoin) }

      it 'returns fiat_open' do
        expect(trade).to be_trade_type_fiat_open
      end
    end
  end

  describe '#type_open?' do
    it 'returns false' do
      expect(trade).not_to be_trade_type_open
    end

    context 'when trade is a fiat_open' do
      subject(:trade) { build(:trade, trade_type: :fiat_open) }

      it 'returns true' do
        expect(trade).to be_trade_type_open
      end
    end

    context 'when trade is a crypto_open' do
      subject(:trade) { build(:trade, trade_type: :crypto_open) }

      it 'returns true' do
        expect(trade).to be_trade_type_open
      end
    end
  end

  describe '#type_close?' do
    it 'returns false' do
      expect(trade).not_to be_trade_type_close
    end

    context 'when trade is a fiat_close' do
      subject(:trade) { build(:trade, trade_type: :fiat_close) }

      it 'returns true' do
        expect(trade).to be_trade_type_close
      end
    end

    context 'when trade is a crypto_close' do
      subject(:trade) { build(:trade, trade_type: :crypto_close) }

      it 'returns true' do
        expect(trade).to be_trade_type_close
      end
    end
  end
end
