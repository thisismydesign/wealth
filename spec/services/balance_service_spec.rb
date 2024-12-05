# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BalanceService do
  subject(:call) { described_class.call(asset:, user:) }

  let(:user) { create(:user) }
  let(:asset) { create(:asset) }

  describe '#call' do
    it 'returns zero' do
      expect(call).to eq(0)
    end

    context 'when there is a trade from the asset' do
      before { create(:trade, from: asset, user:, from_amount: 100) }

      it 'subtracts from the balance' do
        expect(call).to eq(-100)
      end
    end

    context 'when there is a trade to the asset' do
      before { create(:trade, to: asset, user:, to_amount: 100) }

      it 'adds to the balance' do
        expect(call).to eq(100)
      end
    end

    context 'when there is an income for the asset' do
      before { create(:income, asset:, user:, amount: 100) }

      it 'adds to the balance' do
        expect(call).to eq(100)
      end
    end

    context 'when there is a funding for the asset' do
      before { create(:funding, asset:, user:, amount: 100) }

      it 'adds to the balance' do
        expect(call).to eq(100)
      end
    end
  end
end
