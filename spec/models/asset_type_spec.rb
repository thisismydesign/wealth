# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetType do
  subject(:asset_type) { build(:asset_type) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
