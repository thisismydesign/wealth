# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::TradesController', type: :request do
  before { sign_in(create(:user, role: :admin), scope: :user) }

  let!(:trade) { create(:trade) }

  it 'shows trade' do
    get admin_trades_path

    expect(response.body).to include(CGI.escapeHTML(trade.humanized))
  end
end
