# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  render_views

  it 'shows balance' do
    get :index

    expect(response.body).to include('Balance')
  end
end
