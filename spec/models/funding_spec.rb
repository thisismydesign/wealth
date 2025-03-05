# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Funding do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:date) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:asset) }
    it { is_expected.to belong_to(:asset_holder) }
    it { is_expected.to belong_to(:user) }
  end

  describe '.year_eq' do
    it 'returns entity in given year' do
      entity = create(:funding, date: DateTime.now)

      expect(described_class.year_eq(Date.current.year)).to include(entity)
    end

    it 'does not return entity from earlier year' do
      entity = create(:funding, date: 1.year.ago)

      expect(described_class.year_eq(Date.current.year)).not_to include(entity)
    end

    it 'does not return entity from next year' do
      entity = create(:funding, date: 1.year.from_now)

      expect(described_class.year_eq(Date.current.year)).not_to include(entity)
    end
  end
end
