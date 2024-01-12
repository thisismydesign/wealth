# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TotalIncomeService do
  subject(:call) { described_class.call }

  it 'returns 0' do
    expect(call).to eq(0)
  end

  context 'when there are incomes' do
    before { create_list(:income, 2, amount: 1) }

    it 'returns the sum of all incomes converted' do
      allow(CurrencyConverterService).to receive(:call).and_return(1)

      expect(call).to eq(2)
    end
  end
end
