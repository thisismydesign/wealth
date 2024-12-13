# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::ExchangeRatesController', type: :request do
  before do
    sign_in(create(:user, role: :admin), scope: :user)
    create(:exchange_rate, rate: 10_000)
  end

  it 'shows exchange rate' do
    get admin_exchange_rates_path

    expect(response.body).to include('10,000')
  end
end
