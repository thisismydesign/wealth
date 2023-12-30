# frozen_string_literal: true

class TotalDepositsService < ApplicationService
  attr_accessor :year

  def call
    fundings = Asset.where(asset_type: AssetType.find_by(name: 'Currency')).map do |asset|
      {
        ticker: asset.ticker,
        funding: DepositService.call(asset_id: asset.id, year:)
      }
    end

    fundings.filter { |funding| funding[:funding].positive? }
  end
end
