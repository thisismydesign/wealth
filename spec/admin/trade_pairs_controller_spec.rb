# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TradePairsController, type: :controller do
  render_views

  before { sign_in(create(:user)) }

  let!(:trade_pair) { create(:trade_pair) }

  it 'shows trade' do
    get :index

    expect(response.body).to include(CGI.escapeHTML(trade_pair.open_trade.humanized))
  end
end
