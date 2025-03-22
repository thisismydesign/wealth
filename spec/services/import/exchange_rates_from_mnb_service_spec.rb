# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Import::ExchangeRatesFromMnbService do
  describe '#call' do
    let(:request_mock) { Faraday::Response.new(status: 200, body: File.read('spec/fixtures/mnb_rates.html')) }

    before do
      allow(Faraday).to receive(:get).and_return(request_mock)
    end

    it 'creates exchange rates' do
      expect { described_class.call }.to change(ExchangeRate, :count).by(8)
    end
  end
end
