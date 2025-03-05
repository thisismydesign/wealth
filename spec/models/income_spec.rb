# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Income do
  describe 'validations' do
    it { is_expected.to belong_to(:income_type) }
    it { is_expected.to belong_to(:asset) }
    it { is_expected.to belong_to(:source).class_name('Asset').optional(true) }
    it { is_expected.to belong_to(:asset_holder) }

    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:date) }
  end

  describe 'associations' do
    it { is_expected.to have_one(:trade_base_price).dependent(:destroy) }
    it { is_expected.to have_one(:tax_base_price).dependent(:destroy) }
    it { is_expected.to have_many(:prices).dependent(:destroy) }
    it { is_expected.to belong_to(:user) }
  end

  describe '.year_eq' do
    it 'returns entity in given year' do
      entity = create(:income, date: DateTime.now)

      expect(described_class.year_eq(Date.current.year)).to include(entity)
    end

    it 'does not return entity from earlier year' do
      entity = create(:income, date: 1.year.ago)

      expect(described_class.year_eq(Date.current.year)).not_to include(entity)
    end

    it 'does not return entity from next year' do
      entity = create(:income, date: 1.year.from_now)

      expect(described_class.year_eq(Date.current.year)).not_to include(entity)
    end
  end
end
