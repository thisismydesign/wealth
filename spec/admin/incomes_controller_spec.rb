# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::IncomesController', type: :request do
  before do
    sign_in(create(:user, role: :admin), scope: :user)
    create(:income, amount: 10_000)
  end

  it 'shows income' do
    get admin_incomes_path

    expect(response.body).to include('10,000')
  end
end
