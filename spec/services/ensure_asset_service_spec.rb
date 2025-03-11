# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnsureAssetService do
  subject(:call) { described_class.call(name:, type:, user:) }

  let(:type) { AssetType.currency }
  let(:user) { create(:user) }

  context 'when global asset (w/o user) exists' do
    let!(:asset) { create(:asset, ticker: 'USD') }

    context 'when lowercase name is provided' do
      let(:name) { 'usd' }

      it 'returns asset' do
        expect(call).to eq(asset)
      end
    end

    context 'when uppercase name is provided' do
      let(:name) { 'USD' }

      it 'returns asset' do
        expect(call).to eq(asset)
      end
    end
  end

  context 'when personal asset exists' do
    let!(:asset) { create(:asset, ticker: 'USD', user:) }
    let(:name) { 'USD' }

    it 'returns asset' do
      expect(call).to eq(asset)
    end
  end

  context 'when asset does not exist' do
    let(:name) { 'eur' }

    it 'creates asset' do
      expect { call }.to change(Asset, :count).by(1)
    end

    it 'creates asset with upcase ticker' do
      call

      expect(Asset.last).to have_attributes(ticker: 'EUR')
    end

    it 'returns asset' do
      expect(call).to eq(Asset.last)
    end
  end

  context 'when asset exists with different user' do
    before { create(:asset, ticker: 'USD', user: create(:user)) }

    let(:name) { 'USD' }

    it 'creates asset' do
      expect { call }.to change(Asset, :count).by(1)
    end

    it 'creates asset for user' do
      call

      expect(Asset.last).to have_attributes(user:)
    end
  end

  context 'when asset is in mapping' do
    let(:name) { 'SOL03.S' }
    let(:type) { AssetType.crypto }

    it 'creates asset' do
      expect { call }.to change(Asset, :count).by(1)
    end

    it 'creates asset with correct ticker' do
      call

      expect(Asset.last).to have_attributes(ticker: 'SOL')
    end
  end
end
