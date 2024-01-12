# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ExchangeRatesController, type: :controller do
  render_views

  before { create(:exchange_rate, rate: 10_000) }

  it 'shows exchange rate' do
    get :index

    expect(response.body).to include('10,000')
  end
end
