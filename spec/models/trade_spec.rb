# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trade do
  subject(:trade) { build(:trade, from_amount: 40_000, from: eur, to_amount: 1, to: btc) }

  let(:eur) { build(:asset, name: 'Euro', ticker: 'EUR') }
  let(:btc) { build(:asset, name: 'Bitcoin', ticker: 'BTC') }

  describe 'humanized' do
    it 'returns a humanized version of the trade' do
      expect(trade.humanized).to eq('40000 EUR -> 1 BTC')
    end
  end
end
