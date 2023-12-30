# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AssetSourcesController, type: :controller do
  render_views

  let!(:asset_source) { create(:asset_source) }

  it 'shows asset source' do
    get :index

    expect(response.body).to include(asset_source.name)
  end
end
