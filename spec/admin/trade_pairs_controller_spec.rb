# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::TradePairsController', type: :request do
  before { sign_in(create(:user, role: :admin), scope: :user) }

  let!(:trade_pair) { create(:trade_pair) }

  it 'shows trade' do
    get admin_trade_pairs_path

    expect(response.body).to include(CGI.escapeHTML(trade_pair.open_trade.humanized))
  end
end
