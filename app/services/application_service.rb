# frozen_string_literal: true

class ApplicationService
  include ActiveModel::Model

  def self.call(**args, &)
    new(**args).call(&)
  end

  private

  def ensure_asset(ticker)
    asset = Asset.find_by(ticker:)
    unless asset
      Rails.logger.warn("Asset not found: #{ticker}")
      return false
    end

    asset
  end
end
