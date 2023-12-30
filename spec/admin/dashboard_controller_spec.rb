# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  render_views

  it 'shows dashboard' do
    get :index

    expect(response.body).to include('This is the default dashboard page.')
  end
end
