# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetSource do
  subject(:asset_source) { build(:asset_source) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
