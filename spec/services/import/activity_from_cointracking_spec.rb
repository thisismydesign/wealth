# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::ActivityFromCointracking do
  subject(:call) { described_class.call(csv_file:, user:) }

  let(:user) { create(:user) }

  context 'when export contains a sell trade' do
    let(:csv_file) do
      fixture_file_upload(Rails.root.join('spec/fixtures/cointracking_trade_sell.csv'), 'text/csv')
    end

    it 'creates trade' do
      expect { call }.to change(Trade, :count).by(1)
    end

    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(to_amount: 9960.07335, from_amount: 0.12525238,
                                            to: Asset.find_by(ticker: 'USDC'), from: Asset.find_by(ticker: 'BTC'))
    end
  end

  context 'when export contains a buy trade' do
    let(:csv_file) do
      fixture_file_upload(Rails.root.join('spec/fixtures/cointracking_trade_buy.csv'), 'text/csv')
    end

    it 'creates trade' do
      expect { call }.to change(Trade, :count).by(1)
    end

    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(to_amount: 235.1, from_amount: 442.26696026 + 5.24427226,
                                            to: Asset.find_by(ticker: 'AERO'), from: Asset.find_by(ticker: 'USDC'))
    end
  end
end
