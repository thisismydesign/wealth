# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ibkr::CsvSectionParser do
  subject(:call) { described_class.call(csv_file:, section:) }

  let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_instrument.csv'), 'text/csv') }
  let(:section) { 'Financial Instrument Information' }

  it 'returns section data' do
    expect(call).to eq(
      [
        {
          'Asset Category' => 'Stocks',
          'Code' => nil,
          'Conid' => '75776072',
          'Description' => 'ISHARES CORE S&P 500',
          'Listing Exch' => 'IBIS2',
          'Multiplier' => '1',
          'Security ID' => 'IE00B5BMR087',
          'Symbol' => 'CSPX',
          'Type' => 'ETF'
        }
      ]
    )
  end
end
