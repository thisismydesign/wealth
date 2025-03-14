# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ibkr::ImportFundingsService do
  subject(:call) { described_class.call(csv_file:, user:) }

  let(:user) { create(:user) }
  let(:csv_file) { fixture_file_upload(Rails.root.join('spec/fixtures/ibkr_funding.csv'), 'text/csv') }

  it 'creates fundings' do
    expect { call }.to change(Funding, :count).by(2)
  end

  # rubocop:disable RSpec/ExampleLength
  it 'creates deposit with correct attributes' do
    call

    expect(Funding.first).to have_attributes(
      amount: BigDecimal('10000'),
      asset: Asset.find_by(ticker: 'EUR'),
      date: Time.zone.parse('2023-02-09'),
      user:
    )
  end

  it 'creates withdrawal with correct attributes' do
    call

    expect(Funding.last).to have_attributes(
      amount: BigDecimal('-45000'),
      asset: Asset.find_by(ticker: 'EUR'),
      date: Time.zone.parse('2023-12-29'),
      user:
    )
  end
  # rubocop:enable RSpec/ExampleLength

  context 'with custom asset holder' do
    subject(:call) { described_class.call(csv_file:, user:, custom_asset_holder:) }

    let(:custom_asset_holder) { create(:asset_holder, name: 'Custom IBKR', user:) }

    it 'uses the custom asset holder' do
      call

      expect(Funding.first.asset_holder).to eq(custom_asset_holder)
    end
  end
end
