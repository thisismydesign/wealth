# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::IncomesController, type: :controller do
  render_views

  before { create(:income, amount: 10_000) }

  it 'shows income' do
    get :index

    expect(response.body).to include('10,000')
  end
end
