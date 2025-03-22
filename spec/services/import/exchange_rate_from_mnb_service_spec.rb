# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::ExchangeRateFromMnbService do
  describe '#call' do
    subject(:call) { described_class.call(asset:) }

    let(:asset) { create(:asset, ticker: 'EUR') }

    let(:file_path) { 'spec/fixtures/mnb_rates.html' }
    let(:request_mock) { Faraday::Response.new(status: 200, body: File.read(file_path)) }

    before do
      allow(Faraday).to receive(:get).and_return(request_mock)
    end

    it 'creates exchange rates' do
      expect { call }.to change(ExchangeRate, :count).by(4)
    end

    context 'when exchange rate already exists' do
      let(:file_path) { 'spec/fixtures/mnb_single_rate.html' }
      let(:huf) { create(:asset, ticker: 'HUF') }
      let!(:exchange_rate) { create(:exchange_rate, date: Date.new(2024, 12, 31), from: asset, to: huf, rate: 1) }

      it 'does not create a new exchange rate' do
        expect { call }.not_to change(ExchangeRate, :count)
      end

      it 'updates existing exchange rate' do
        expect { call }.to change { exchange_rate.reload.rate }.from(1).to(410.09)
      end
    end
  end
end
