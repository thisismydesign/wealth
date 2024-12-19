# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnsureAssetService do
  subject(:call) { described_class.call(ticker:, asset_type:, user:) }

  let(:asset_type) { AssetType.currency }
  let(:user) { create(:user) }

  context 'when asset exists without user' do
    let!(:asset) { create(:asset, ticker: 'USD') }

    context 'when lowercase ticker is provided' do
      let(:ticker) { 'usd' }

      it 'returns asset' do
        expect(call).to eq(asset)
      end
    end

    context 'when uppercase ticker is provided' do
      let(:ticker) { 'USD' }

      it 'returns asset' do
        expect(call).to eq(asset)
      end
    end
  end

  context 'when asset exists with user' do
    let!(:asset) { create(:asset, ticker: 'USD', user:) }
    let(:ticker) { 'USD' }

    it 'returns asset' do
      expect(call).to eq(asset)
    end
  end

  context 'when asset does not exist' do
    let(:ticker) { 'eur' }

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

    let(:ticker) { 'USD' }

    it 'creates asset' do
      expect { call }.to change(Asset, :count).by(1)
    end

    it 'creates asset for user' do
      call

      expect(Asset.last).to have_attributes(user:)
    end
  end
end
