# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::AssetTypesController', type: :request do
  before { sign_in(create(:user, role: :admin), scope: :user) }

  let!(:asset_type) { create(:asset_type) }

  it 'shows asset type' do
    get admin_asset_types_path

    expect(response.body).to include(asset_type.name)
  end
end
