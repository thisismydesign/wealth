# frozen_string_literal: true

module Ibkr
  class ImportFundingsService < ApplicationService
    attr_accessor :csv_file, :user, :custom_asset_holder

    def call
      funding_data = Ibkr::CsvSectionParser.call(csv_file:, section: 'Deposits & Withdrawals')

      funding_data.each do |row|
        import_funding_from_section_data(row)
      end
    end

    private

    def import_funding_from_section_data(row)
      asset = EnsureAssetService.call(name: row['Currency'], type: AssetType.currency, user:)

      return unless asset

      Funding.where(
        asset:,
        asset_holder:,
        date: row['Settle Date'],
        amount: to_big_decimal(row['Amount']),
        user:
      ).first_or_create!
    end

    def asset_holder
      @asset_holder ||= custom_asset_holder || AssetHolder.ibkr
    end

    def to_big_decimal(amount)
      amount.delete(',').to_d
    end
  end
end
