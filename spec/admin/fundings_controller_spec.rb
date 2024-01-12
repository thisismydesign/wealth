# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::FundingsController, type: :controller do
  render_views

  let!(:funding) { create(:funding) }

  it 'shows funding' do
    get :index

    expect(response.body).to include(funding.amount.to_s)
  end
end
