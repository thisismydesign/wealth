# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TotalIncomeService do
  subject(:call) { described_class.call }

  it 'returns 0' do
    expect(call).to eq(0)
  end

  context 'when there are incomes' do
    before do
      create_list(:income, 2, amount: 1).each do |income|
        create(:price, priceable: income, amount: 1, asset: Asset.tax_base)
      end
    end

    it 'returns the sum of all income prices' do
      allow(CurrencyConverterService).to receive(:call).and_return(1)

      expect(call).to eq(2)
    end
  end
end
