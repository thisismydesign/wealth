# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ExchangeRatesController, type: :controller do
  render_views

  let!(:exchange_rate) { create(:exchange_rate) }

  it 'shows exchange rate' do
    get :index

    expect(response.body).to include(exchange_rate.rate.to_s)
  end
end
