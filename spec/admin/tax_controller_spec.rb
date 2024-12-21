# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::TaxController', type: :request do
  before do
    sign_in(create(:user, role: :user), scope: :user)
    base = Asset.tax_base
    btc = create(:asset, ticker: 'BTC', asset_type: AssetType.crypto)
    open_trade = create(:trade, from_amount: 40_000, from: base, to_amount: 1, to: btc, date: 1.day.ago)
    close_trade = create(:trade, from_amount: 1, to_amount: 45_000, from: btc, to: base)
    create(:trade_pair, open_trade:, close_trade:)
    create(:exchange_rate, from: base, to: base, date: 1.day.ago, rate: 1)
    create(:exchange_rate, from: base, to: base, date: Time.zone.today, rate: 1)
    create(:price, priceable: open_trade, asset: base, amount: 40_000 * 350)
    create(:price, priceable: close_trade, asset: base, amount: 45_000 * 350)
  end

  it 'shows trade' do
    get admin_tax_path

    expect(response.body).to include('General Tax Overview')
  end
end
