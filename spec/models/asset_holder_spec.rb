# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetHolder do
  subject(:asset_holder) { build(:asset_holder) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
end
