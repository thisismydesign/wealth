# frozen_string_literal: true

class EnsureAssetService < ApplicationService
  attr_accessor :ticker, :asset_type, :user

  def call
    asset_scope.where('upper(ticker) = ?', ticker.upcase).first_or_create!(asset_type:, ticker: ticker.upcase, user:)
  end

  private

  def asset_scope
    AssetPolicy::Scope.new(user, Asset).resolve
  end
end
