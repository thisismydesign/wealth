# frozen_string_literal: true

class EnsureAssetService < ApplicationService
  attr_accessor :ticker, :asset_type

  def call
    Asset.where('upper(ticker) = ?', ticker.upcase).first_or_create!(asset_type:, ticker: ticker.upcase)
  end
end
