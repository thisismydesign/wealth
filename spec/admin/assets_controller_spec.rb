# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AssetsController, type: :controller do
  render_views

  let!(:asset) { create(:asset) }

  it 'shows asset' do
    get :index

    expect(response.body).to include(asset.name)
  end
end
