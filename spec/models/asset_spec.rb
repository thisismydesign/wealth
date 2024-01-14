# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset do
  subject(:asset) { build(:asset) }

  it { is_expected.to belong_to(:asset_type) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:ticker) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:ticker).case_insensitive }

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
