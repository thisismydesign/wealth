# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportActivityFromIbkrService do
  subject(:call) { described_class.call(csv_file:, user:) }

  let(:user) { create(:user) }

  context 'when export contains a stock trade' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_stock_trade.csv'), 'text/csv') }

    it 'creates trades' do
      expect { call }.to change(Trade, :count).by(2)
    end

    it 'creates open trade with correct attributes' do
      call

      expect(Trade.first).to have_attributes(
        from_amount: BigDecimal('16511.273699'), from: Asset.find_by(ticker: 'USD'), to_amount: BigDecimal('2200'),
        to: Asset.find_by(ticker: 'LON:NDIA'), date: Time.zone.parse('2023-06-29, 04:00:06'), user:
      )
    end

    it 'creates close trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(
        from_amount: BigDecimal('2200'), from: Asset.find_by(ticker: 'LON:NDIA'), to: Asset.find_by(ticker: 'USD'),
        to_amount: BigDecimal('18677.436897755'), date: Time.zone.parse('2023-12-27, 03:00:21'), user:
      )
    end
  end

  context 'when export contains a forex trade' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_forex_trade.csv'), 'text/csv') }

    it 'creates trades' do
      expect { call }.to change(Trade, :count).by(1)
    end

    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(
        to_amount: BigDecimal('16372.993094'), to: Asset.find_by(ticker: 'USD'), from: Asset.find_by(ticker: 'EUR'),
        date: Time.zone.parse('2023-06-29, 04:01:30'), from_amount: BigDecimal('14998.16264'), user:
      )
    end
  end

  context 'when export contains funding' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_funding.csv'), 'text/csv') }

    it 'creates fundings' do
      expect { call }.to change(Funding, :count).by(2)
    end

    it 'creates deposit with correct attributes' do
      call

      expect(Funding.first).to have_attributes(
        amount: BigDecimal('10000'), asset: Asset.find_by(ticker: 'EUR'), date: Time.zone.parse('2023-02-09'),
        user:
      )
    end

    it 'creates withdrawal with correct attributes' do
      call

      expect(Funding.last).to have_attributes(
        amount: BigDecimal('-45000'), asset: Asset.find_by(ticker: 'EUR'), date: Time.zone.parse('2023-12-29'),
        user:
      )
    end
  end

  context 'when export contains dividend' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_dividends.csv'), 'text/csv') }

    it 'creates income' do
      expect { call }.to change(Income, :count).by(1)
    end

    it 'creates income with correct attributes' do
      call

      expect(Income.last).to have_attributes(
        amount: BigDecimal('4.99'), asset: Asset.find_by(ticker: 'USD'), date: Time.zone.parse('2023-03-29'),
        source: Asset.find_by(ticker: 'AMS:VUSA'), income_type: IncomeType.dividend, user:
      )
    end
  end

  context 'when export contains interest' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_interest.csv'), 'text/csv') }

    it 'creates income' do
      expect { call }.to change(Income, :count).by(1)
    end

    it 'creates income with correct attributes' do
      call

      expect(Income.last).to have_attributes(
        amount: BigDecimal('2.08'), asset: Asset.find_by(ticker: 'EUR'), date: Time.zone.parse('2023-03-29'),
        source: Asset.find_by(ticker: 'EUR'), income_type: IncomeType.interest, user:
      )
    end
  end

  context 'when export contains fee' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_fee.csv'), 'text/csv') }

    it 'creates trade' do
      expect { call }.to change(Trade, :count).by(1)
    end

    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(
        to_amount: BigDecimal('0'), to: Asset.find_by(ticker: 'EUR'), from: Asset.find_by(ticker: 'EUR'),
        date: Time.zone.parse('2021-06-03'), from_amount: BigDecimal('8.18'), user:
      )
    end
  end
end
