# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportActivityFromKrakenService do
  subject(:call) { described_class.call(csv_file:) }

  context 'when export contains a spend & receive pair' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/kraken_spend_receive_pair.csv'), 'text/csv') }

    it 'creates trade' do
      expect { call }.to change(Trade, :count).by(1)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(
        from_amount: BigDecimal('5'),
        from: Asset.find_by(ticker: 'EUR'),
        to_amount: BigDecimal('64.64'),
        to: Asset.find_by(ticker: 'DOGE'),
        date: Time.zone.parse('2023-02-13 15:30:45')
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'when export contains a trade pair' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/kraken_trade_pair.csv'), 'text/csv') }

    it 'creates trade' do
      expect { call }.to change(Trade, :count).by(1)
    end

    # rubocop:disable RSpec/ExampleLength
    it 'creates trade with correct attributes' do
      call

      expect(Trade.last).to have_attributes(
        from_amount: BigDecimal('1000'),
        from: Asset.find_by(ticker: 'EUR'),
        to_amount: BigDecimal('0.04683841'),
        to: Asset.find_by(ticker: 'BTC'),
        date: Time.zone.parse('2023-02-08 20:29:08')
      )
    end
    # rubocop:enable RSpec/ExampleLength
  end

  context 'when trade already exists' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/kraken_spend_receive_pair.csv'), 'text/csv') }

    it 'does not create new trade' do
      call

      expect { call }.not_to change(Trade, :count)
    end
  end
end
