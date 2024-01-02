# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TradePair do
  it { is_expected.to belong_to(:open_trade).class_name('Trade') }
  it { is_expected.to belong_to(:close_trade).class_name('Trade') }
end
