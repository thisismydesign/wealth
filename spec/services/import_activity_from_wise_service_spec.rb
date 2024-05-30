# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportActivityFromWiseService do
  subject(:call) { described_class.call(csv_file:) }

  context 'when export contains interest' do
    let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/wise_interest.csv'), 'text/csv') }

    it 'creates income' do
      expect { call }.to change(Income, :count).by(1)
    end

    it 'creates income with correct attributes' do
      call

      expect(Income.first).to have_attributes(
        amount: BigDecimal('1.51'), asset: Asset.find_by(ticker: 'EUR'), date: Time.zone.parse('2023-12-05'),
        source: Asset.find_by(ticker: 'EUR'), income_type: IncomeType.interest
      )
    end
  end
end
