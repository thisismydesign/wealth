# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AssetHoldersController, type: :controller do
  render_views

  before { sign_in(create(:user, role: :admin)) }

  let!(:asset_holder) { create(:asset_holder) }

  it 'shows asset holder' do
    get :index

    expect(response.body).to include(asset_holder.name)
  end
end
