# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tax::ClosedPositionsService do
  describe '#call' do
    subject(:call) { described_class.call(user:) }

    let(:user) { create(:user) }

    it 'empty collection' do
      expect(call).to be_empty
    end

    context 'when is a trade to currency' do
      let(:close_trade) do
        create(:trade, user:, to: create(:asset, asset_type: AssetType.currency),
                       from: create(:asset, asset_type: AssetType.crypto))
      end

      it 'returns trade' do
        expect(call).to eq([close_trade])
      end
    end
  end
end
