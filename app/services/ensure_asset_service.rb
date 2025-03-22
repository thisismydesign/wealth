# frozen_string_literal: true

class EnsureAssetService < ApplicationService
  attr_accessor :name, :type, :user

  ASSET_MAPPING = {
    # Kraken
    'ZEUR' => { ticker: 'EUR', asset_type: AssetType.currency },
    'XXBT' => { ticker: 'BTC', asset_type: AssetType.crypto },
    'XETH' => { ticker: 'ETH', asset_type: AssetType.crypto },
    'XXDG' => { ticker: 'DOGE', asset_type: AssetType.crypto },
    'XBT.M' => { ticker: 'BTC', asset_type: AssetType.crypto },
    'SOL03.S' => { ticker: 'SOL', asset_type: AssetType.crypto },
    # Cointracking
    'SOL2' => { ticker: 'SOL', asset_type: AssetType.crypto },
    'AERO4' => { ticker: 'AERO', asset_type: AssetType.crypto }
  }.freeze

  def call
    ticker = ASSET_MAPPING.dig(name, :ticker) || name
    asset_type = ASSET_MAPPING.dig(name, :asset_type) || type

    scope.where(ticker: ticker.upcase).first_or_create!(asset_type:, ticker: ticker.upcase, user:, name: ticker)
  end

  private

  def scope
    user ? AssetPolicy::Scope.new(user, Asset).resolve : Asset.all
  end
end
