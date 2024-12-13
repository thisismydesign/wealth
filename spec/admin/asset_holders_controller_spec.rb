# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::AssetHoldersController', type: :request do
  before { sign_in(create(:user, role: :admin), scope: :user) }

  let!(:asset_holder) { create(:asset_holder) }

  it 'shows asset holder' do
    get admin_asset_holders_path

    expect(response.body).to include(asset_holder.name)
  end
end
