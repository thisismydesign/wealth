# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tax::PositionsService do
  describe '#call' do
    subject(:call) { described_class.call(user:) }

    let(:user) { create(:user) }

    it 'empty collection' do
      expect(call).to be_empty
    end

    context 'when trade_type is passed' do
      subject(:call) { described_class.call(user:, trade_type: :fiat_close) }

      before do
        create(:trade, user:, to: create(:asset, asset_type: AssetType.currency),
                       from: create(:asset, asset_type: AssetType.crypto))
        create(:trade, user:, from: create(:asset, asset_type: AssetType.currency),
                       to: create(:asset, asset_type: AssetType.crypto))
      end

      it 'filters by trade_type' do
        expect(call.size).to eq(1)
      end
    end
  end
end
