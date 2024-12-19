# frozen_string_literal: true

class EnsureAssetService < ApplicationService
  attr_accessor :ticker, :asset_type, :user

  def call
    scope.where('upper(ticker) = ?', ticker.upcase).first_or_create!(asset_type:, ticker: ticker.upcase, user:,
                                                                     name: ticker)
  end

  private

  def scope
    AssetPolicy::Scope.new(user, Asset).resolve
  end
end
