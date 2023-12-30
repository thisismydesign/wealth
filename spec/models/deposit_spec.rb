# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Deposit do
  subject(:deposit) { build(:deposit) }

  it { is_expected.to belong_to(:asset) }
end
