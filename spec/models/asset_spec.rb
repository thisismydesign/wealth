# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Asset do
  subject(:asset) { build(:asset) }

  it { is_expected.to belong_to(:asset_type) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:ticker) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:ticker).case_insensitive }
end
