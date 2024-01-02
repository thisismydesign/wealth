# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoundService do
  subject(:call) { described_class.call(decimal: decimal.to_d) }

  context 'when decimal is zero' do
    let(:decimal) { 0 }

    it 'returns zero' do
      expect(call).to eq(0)
    end
  end

  context 'when decimal is at least 2 digits' do
    let(:decimal) { 12.5 }

    it 'rounds the decimal' do
      expect(call).to eq(13)
    end
  end

  context 'when decimal is less than 2 digits' do
    let(:decimal) { 1.2356 }

    it 'rounds the decimal to 2 non-zero digits' do
      expect(call).to eq(1.24)
    end
  end

  context 'when decimal is less than 2 digits and round' do
    let(:decimal) { 1 }

    it 'stays round' do
      expect(call).to eq(1)
    end
  end

  context 'when decimal has leading zeros' do
    let(:decimal) { 0.00126 }

    it 'rounds the decimal to 2 non-zero digits' do
      expect(call.to_f).to eq(0.0013)
    end
  end
end
