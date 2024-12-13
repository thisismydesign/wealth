# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::AssetsController', type: :request do
  before { sign_in(create(:user, role: :admin), scope: :user) }

  let!(:asset) { create(:asset) }

  it 'shows asset' do
    get admin_assets_path

    expect(response.body).to include(CGI.escapeHTML(asset.name))
  end
end
