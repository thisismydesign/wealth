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
end
