# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tax::OpenPositionsService do
  subject(:call) do
    described_class.call(year: Time.zone.today.year, accept_previous_years: true, to_asset_type: AssetType.crypto)
  end

  let(:from) { create(:asset, name: 'USD', asset_type: AssetType.currency) }
  let(:to) { create(:asset, name: 'BTC', asset_type: AssetType.crypto) }

  before { create(:trade, from:, to:, from_amount: 100_000, to_amount: 1) }

  describe '#call' do
    it 'returns open position' do
      expect(call.first).to have_attributes(from:, to:, from_amount: 100_000, to_amount: 1)
    end

    context 'with multiple trades of the same trade pair' do
      before { create(:trade, from:, to:, from_amount: 100_000, to_amount: 1) }

      it 'returns aggregated open position' do
        expect(call.first).to have_attributes(from:, to:, from_amount: 200_000, to_amount: 2)
      end
    end
  end
end
