# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::IncomesController, type: :controller do
  render_views

  let!(:income) { create(:income) }

  it 'shows income' do
    get :index

    expect(response.body).to include(income.amount.to_s)
  end
end
