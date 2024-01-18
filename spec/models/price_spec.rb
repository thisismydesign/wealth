# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price do
  it { is_expected.to belong_to(:asset) }
  it { is_expected.to belong_to(:priceable) }
  it { is_expected.to validate_presence_of(:amount) }

  describe 'validations' do
    context 'when priceable is not Trade or Income' do
      subject(:price) { build(:price, priceable: build(:asset)) }

      it 'is invalid' do
        expect(price).not_to be_valid
      end

      it 'has a custom error message' do
        price.valid?
        expect(price.errors[:priceable_type]).to include('must be either Trade or Income')
      end
    end
  end
end
