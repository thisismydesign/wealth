# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Funding do
  subject(:funding) { build(:funding) }

  it { is_expected.to belong_to(:asset) }
  it { is_expected.to belong_to(:asset_source) }
end
