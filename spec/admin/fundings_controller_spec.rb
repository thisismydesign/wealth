# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::FundingsController', type: :request do
  before do
    sign_in(create(:user, role: :admin), scope: :user)
    create(:funding, amount: 10_000)
  end

  it 'shows funding' do
    get admin_fundings_path

    expect(response.body).to include('10,000')
  end
end
