# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::DepositsController, type: :controller do
  render_views

  let!(:deposit) { create(:deposit) }

  it 'shows deposit' do
    get :index

    expect(response.body).to include(deposit.amount.to_s)
  end
end
