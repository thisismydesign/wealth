# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ibkr::TickerMapperService do
  subject(:call) { described_class.call(csv_file:) }

  context 'when export contains a stock trade' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_instrument.csv'), 'text/csv') }

    it 'returns mapping' do
      expect(call).to eq({ 'CSPX' => 'FRA:CSPX' })
    end
  end

  context 'when export contains different headers' do
    let(:csv_file) do
      fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_instrument_different_headers.csv'), 'text/csv')
    end

    it 'returns mapping' do
      expect(call).to eq({ 'VUSD' => 'LON:VUSD' })
    end
  end
end
