# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TradesController, type: :controller do
  render_views

  let!(:trade) { create(:trade) }

  it 'shows trade' do
    get :index

    expect(response.body).to include(CGI.escapeHTML(trade.humanized))
  end
end
