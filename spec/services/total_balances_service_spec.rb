# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TotalBalancesService do
  subject(:call) { described_class.call(user:) }

  let(:user) { create(:user) }

  describe '#call' do
    it 'returns an array' do
      expect(call).to eq([])
    end

    context 'when user has funding' do
      let!(:funding) { create(:funding, user:) }

      it 'returns the total balances' do
        expect(call).to contain_exactly(
          hash_including(asset_holder: funding.asset_holder, asset: funding.asset, balance: funding.amount)
        )
      end
    end
  end
end
