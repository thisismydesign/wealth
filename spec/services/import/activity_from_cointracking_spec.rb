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

    # rubocop:disable RSpec/ExampleLength
    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(
        to_amount: 9960.07335, from_amount: 0.12525238,
        to: Asset.find_by(ticker: 'USDC'), from: Asset.find_by(ticker: 'BTC'),
        date: DateTime.parse('28.02.2025 11:29:11')
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'when export contains a buy trade' do
    let(:csv_file) do
      fixture_file_upload(Rails.root.join('spec/fixtures/cointracking_trade_buy.csv'), 'text/csv')
    end

    it 'creates trade' do
      expect { call }.to change(Trade, :count).by(1)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(
        to_amount: 235.1, from_amount: 442.26696026 + 5.24427226,
        to: Asset.find_by(ticker: 'AERO'), from: Asset.find_by(ticker: 'USDC'),
        date: DateTime.parse('06.12.2024 02:38:22')
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'when export contains a deposit' do
    let(:csv_file) do
      fixture_file_upload(Rails.root.join('spec/fixtures/cointracking_deposit.csv'), 'text/csv')
    end

    it 'creates funding' do
      expect { call }.to change(Funding, :count).by(1)
    end

    it 'creates funding with correct attributes' do
      call

      expect(Funding.last).to have_attributes(
        amount: BigDecimal('4000.00000000'), asset: Asset.find_by(ticker: 'EUR'),
        date: DateTime.parse('19.12.2024 10:47:44'), asset_holder: AssetHolder.find_by(name: 'Kraken'), user:
      )
    end
  end
end
