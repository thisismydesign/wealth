# frozen_string_literal: true

module Import
  class ImportService < ApplicationService
    def ensure_asset(ticker)
      asset = Asset.find_by(ticker:)
      unless asset
        Rails.logger.warn("Asset not found: #{ticker}")
        return false
      end

      asset
    end
  end
end
