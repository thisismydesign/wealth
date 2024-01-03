# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Income do
  subject(:income) { build(:income) }

  it { is_expected.to belong_to(:income_type) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:date) }
end
