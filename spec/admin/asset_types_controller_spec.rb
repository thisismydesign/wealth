# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AssetTypesController, type: :controller do
  render_views

  before { sign_in(create(:user, role: :admin)) }

  let!(:asset_type) { create(:asset_type) }

  it 'shows asset type' do
    get :index

    expect(response.body).to include(asset_type.name)
  end
end
