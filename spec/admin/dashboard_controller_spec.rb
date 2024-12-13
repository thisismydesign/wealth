# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::DashboardController', type: :request do
  before { sign_in(create(:user, role: :admin), scope: :user) }

  it 'shows balance' do
    get admin_dashboard_path

    expect(response.body).to include('Balance')
  end
end
