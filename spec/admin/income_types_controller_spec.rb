# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::IncomeTypesController', type: :request do
  before { sign_in(create(:user, role: :admin), scope: :user) }

  let!(:income_type) { create(:income_type) }

  it 'shows income type' do
    get admin_income_types_path

    expect(response.body).to include(income_type.name)
  end
end
