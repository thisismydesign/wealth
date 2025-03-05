# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset do
  subject(:asset) { build(:asset) }

  describe 'associations' do
    it { is_expected.to belong_to(:asset_type) }
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:ticker) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:ticker).case_insensitive.scoped_to(:user_id) }

    context 'when global asset is present' do
      before { create(:asset, ticker: 'USD', user: nil) }

      it 'cannot create personal asset with same ticker' do
        expect(build(:asset, ticker: 'USD', user: create(:user))).not_to be_valid
      end
    end

    context 'when ticker is lowercase' do
      it 'is not valid' do
        expect(build(:asset, ticker: 'bla')).not_to be_valid
      end
    end
  end

  describe '.tax_base' do
    it 'returns tax base asset' do
      expect(described_class.tax_base.ticker).to eq Rails.application.config.x.tax_base_currency
    end
  end

  describe '.trade_base' do
    it 'returns trade base asset' do
      expect(described_class.trade_base.ticker).to eq Rails.application.config.x.trade_base_currency
    end
  end
end
