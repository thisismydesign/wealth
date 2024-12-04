# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::IncomeTypesController, type: :controller do
  render_views

  before { sign_in(create(:user, role: :admin)) }

  let!(:income_type) { create(:income_type) }

  it 'shows income type' do
    get :index

    expect(response.body).to include(income_type.name)
  end
end
