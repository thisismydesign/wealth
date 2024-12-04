# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::FundingsController, type: :controller do
  render_views

  before do
    sign_in(create(:user, role: :admin))
    create(:funding, amount: 10_000)
  end

  it 'shows funding' do
    get :index

    expect(response.body).to include('10,000')
  end
end
