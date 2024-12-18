# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetHolder do
  subject(:asset_holder) { build(:asset_holder) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
