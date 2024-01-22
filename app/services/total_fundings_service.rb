# frozen_string_literal: true

class TotalFundingsService < ApplicationService
  attr_accessor :year

  def call
    fundings = Asset.where(asset_type: AssetType.find_by(name: 'Currency')).map do |asset|
      {
        ticker: asset.ticker,
        funding: FundingService.call(asset:, year:)
      }
    end

    fundings.filter { |funding| funding[:funding].positive? }
  end
end
