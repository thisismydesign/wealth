# frozen_string_literal: true

require 'csv'

module Import
  class ActivityFromCointracking < ApplicationService
    attr_accessor :csv_file, :user

    def call
      return if csv_file.blank?

      CSV.foreach(csv_file.path, headers: true) do |row|
        import_trade(row) if trade?(row)
        import_deposit(row) if deposit?(row)
      end
    end

    private

    def trade?(row)
      row['Type'] == 'Trade'
    end

    def deposit?(row)
      row['Type'] == 'Deposit'
    end

    def import_trade(row)
      Trade.where(to_amount: row['Buy'].to_f, to: asset(row[2]),
                  from_amount: from_amount(row), from: asset(row[4]),
                  date: row['Date'], asset_holder: asset_holder(row['Exchange']),
                  user:).first_or_create!
    end

    def import_deposit(row)
      Funding.where(
        asset: asset(row[2]),
        date: row['Date'],
        amount: row['Buy'].to_f,
        asset_holder: asset_holder(row['Exchange']),
        user:
      ).first_or_create!
    end

    def from_amount(row)
      from_asset = asset(row[4])
      fee_asset = asset(row[6])

      # Fees are not part of the to and from amounts
      # When buying crypto fee should be added to "from amount"
      # I.e. 100.100 USD -> 1 BTC (bought 1 BTC with 100.000 USD + 100 USD fee)
      # When selling crypto fee should NOT be subtracted from "to amount"
      # I.e. 1 BTC -> 99.900 USD (sold 1 BTC for 99.900 USD + 100 USD fee)
      if fee_asset == from_asset
        row['Sell'].to_f + row['Fee'].to_f
      else
        row['Sell'].to_f
      end
    end

    def asset(asset_name)
      EnsureAssetService.call(name: asset_name, type: AssetType.crypto, user:)
    end

    def asset_holder(name)
      AssetHolder.where(name:).first_or_create!(user:)
    end
  end
end
