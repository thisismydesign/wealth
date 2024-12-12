# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FundingService do
  subject(:call) { described_class.call(asset:, user:) }

  let(:user) { create(:user) }
  let(:asset) { create(:asset) }

  describe '#call' do
    it 'returns zero' do
      expect(call).to eq(0)
    end

    context 'when there is a funding for the asset' do
      before { create(:funding, asset:, user:, amount: 100) }

      it 'returns the funding amount' do
        expect(call).to eq(100)
      end
    end
  end
end
